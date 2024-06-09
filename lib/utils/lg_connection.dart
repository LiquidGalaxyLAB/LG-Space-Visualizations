import 'dart:io';
import 'package:ssh2/ssh2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lg_space_visualizations/utils/kml/kml_makers.dart';

/// Global instance of [LGConnection].
LGConnection lgConnection = LGConnection();

/// Manages a connection to the Liquid Galaxy system using SSH.
class LGConnection {
  /// SSH client for managing the connection.
  SSHClient? client;

  /// Number of screens in the Liquid Galaxy system.
  int? screenAmount;

  /// Creates an [LGConnection] instance.
  LGConnection();

  /// Checks if the SSH client is connected.
  ///
  /// Returns `true` if connected, `false` otherwise.
  Future<bool> isConnected() async {
    return client == null ? false : await client!.isConnected();
  }

  /// Disconnects the SSH client if connected.
  Future<void> disconnect() async {
    if (await isConnected()) {
      await client!.disconnect();
    }
  }

  /// Connects to the Liquid Galaxy system
  ///
  /// Returns `true` if the connection is successful, `false` otherwise.
  Future<bool> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('lg_ip') ||
        !prefs.containsKey('lg_port') ||
        !prefs.containsKey('lg_username') ||
        !prefs.containsKey('lg_password')) {
      return false;
    }

    client = SSHClient(
      host: prefs.getString('lg_ip')!,
      port: prefs.getInt('lg_port')!,
      username: prefs.getString('lg_username')!,
      passwordOrKey: prefs.getString('lg_password')!,
    );

    try {
      final connectionResult =
          await client!.connect().timeout(const Duration(seconds: 8));
      if (connectionResult == 'session_connected') {
        screenAmount = await getScreenAmount() ?? 1;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the number of screens in the Liquid Galaxy system.
  ///
  /// Returns the number of screens or `null` if not connected or on failure.
  Future<int?> getScreenAmount() async {
    if (await isConnected() == false) {
      return null;
    }

    String? screenAmount = await client!
        .execute("grep -oP '(?<=DHCP_LG_FRAMES_MAX=).*' personavars.txt");

    if (screenAmount != null) {
      return int.parse(screenAmount);
    } else {
      return null;
    }
  }

  /// Sends a KML file to the Liquid Galaxy system.
  ///
  /// [kml] is the KML content to send.
  Future<void> sendKml(String kml) async {
    if (await isConnected() == false) {
      return;
    }

    const fileName = 'upload.kml';

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    file.writeAsStringSync(kml);

    await client!.connectSFTP();
    await client!.sftpUpload(
        path: file.path,
        toPath: '/var/www/html',
        callback: (progress) {
          print('Sent $progress');
        });
    await client!
        .execute('echo "http://lg1:81/$fileName" > /var/www/html/kmls.txt');
  }

  /// Sends a KML file to a specific slave screen.
  ///
  /// [screenNumber] is the screen number.
  /// [kml] is the KML content to send.
  Future<void> sendKMLToSlave(int screenNumber, String kml) async {
    if (await isConnected() == false) {
      return;
    }

    try {
      await client!
          .execute("echo '$kml' > /var/www/html/kml/slave_$screenNumber.kml");
    } catch (e) {
      print(e);
    }
  }

  /// Gets the first screen number.
  int get firstScreen {
    if (screenAmount == 1) {
      return 1;
    }
    return (screenAmount ?? 5 / 2).floor() + 2;
  }

  /// Gets the last screen number.
  int get lastScreen {
    if (screenAmount == 1) {
      return 1;
    }
    return (screenAmount ?? 5 / 2).floor();
  }

  /// Relaunches the Liquid Galaxy services.
  Future<void> relaunch() async {
    if (await isConnected() == false) {
      return;
    }

    final pw = client!.passwordOrKey;
    final user = client!.username;

    for (var i = screenAmount ?? 5; i >= 1; i--) {
      try {
        final relaunchCommand = """RELAUNCH_CMD="\\
if [ -f /etc/init/lxdm.conf ]; then
  export SERVICE=lxdm
elif [ -f /etc/init/lightdm.conf ]; then
  export SERVICE=lightdm
else
  exit 1
fi
if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
  echo $pw | sudo -S service \\\${SERVICE} start
else
  echo $pw | sudo -S service \\\${SERVICE} restart
fi
" && sshpass -p $pw ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";
        await client!
            .execute('"/home/$user/bin/lg-relaunch" > /home/$user/log.txt');
        await client!.execute(relaunchCommand);
      } catch (e) {
        print(e);
      }
    }
  }

  /// Clears the KML files from the Liquid Galaxy system.
  ///
  /// [keepLogos] indicates whether to keep the logo overlays.
  Future<void> clearKml({bool keepLogos = false}) async {
    if (await isConnected() == false) {
      return;
    }
    String query =
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';

    for (var i = 2; i <= (screenAmount ?? 5); i++) {
      String blankKml = KMLMakers.generateBlank('slave_$i');
      query += " && echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
    }

    await client!.execute(query);

    if (keepLogos) {
      sendKMLToSlave(
          lastScreen,
          //TODO: Change the path to the correct one and fix ratio
          KMLMakers.screenOverlayImage(
              "https://i.ibb.co/tpFntyt/logos.png", 2864 / 3000));
    }
  }

  /// Reboots the Liquid Galaxy system.
  Future<void> reboot() async {
    if (await isConnected() == false) {
      return;
    }

    final pw = client!.passwordOrKey;

    for (var i = (screenAmount ?? 5); i >= 1; i--) {
      try {
        await client!
            .execute('sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"');
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Sets the refresh interval
  Future<void> setRefresh() async {
    if (await isConnected() == false) {
      return;
    }

    final pw = client!.passwordOrKey;

    const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
    const replace =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    final command =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    final clear =
        'echo $pw | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';

    for (var i = 2; i <= (screenAmount ?? 5); i++) {
      final clearCmd = clear.replaceAll('{{slave}}', i.toString());
      final cmd = command.replaceAll('{{slave}}', i.toString());
      String query = 'sshpass -p $pw ssh -t lg$i \'{{cmd}}\'';

      try {
        await client!.execute(query.replaceAll('{{cmd}}', clearCmd));
        await client!.execute(query.replaceAll('{{cmd}}', cmd));
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    await reboot();
  }

  /// Resets the refresh interval
  Future<void> resetRefresh() async {
    if (await isConnected() == false) {
      return;
    }

    final pw = client!.passwordOrKey;

    const search =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    const replace = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';

    final clear =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    for (var i = 2; i <= (screenAmount ?? 5); i++) {
      final cmd = clear.replaceAll('{{slave}}', i.toString());
      String query = 'sshpass -p $pw ssh -t lg$i \'$cmd\'';

      try {
        await client!.execute(query);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    await reboot();
  }

  /// Shuts down the Liquid Galaxy system.
  Future<void> shutdown() async {
    if (await isConnected() == false) {
      return;
    }

    final pw = client!.passwordOrKey;

    for (var i = screenAmount ?? 5; i >= 1; i--) {
      try {
        await client!.execute(
            'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S poweroff"');
      } catch (e) {
        print(e);
      }
    }
  }
}