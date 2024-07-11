import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/services.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/kml/kml_makers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global instance of [LGConnection].
LGConnection lgConnection = LGConnection();

/// Manages a connection to the Liquid Galaxy system using SSH.
class LGConnection {
  /// SSH client for managing the connection.
  SSHClient? client;

  /// Number of screens in the Liquid Galaxy system, default is 5.
  int screenAmount = 5;

  /// Creates an [LGConnection] instance.
  LGConnection();

  /// Checks if the SSH client is connected.
  ///
  /// Returns `true` if connected, `false` otherwise.
  bool isConnected() {
    return !(client?.isClosed ?? true);
  }

  /// Disconnects the SSH client if connected.
  void disconnect() {
    if (isConnected()) {
      client?.close();
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
    try {
      final socket = await SSHSocket.connect(
        prefs.getString('lg_ip')!,
        prefs.getInt('lg_port')!,
      ).timeout(const Duration(seconds: 8));

      client = SSHClient(
        socket,
        username: prefs.getString('lg_username')!,
        onPasswordRequest: () => prefs.getString('lg_password')!,
      );

      await client!.authenticated;
      screenAmount = await getScreenAmount();
      await showLogos();
    } catch (e) {
      return false;
    }
    return true;
  }

  /// Retrieves the number of screens in the Liquid Galaxy system.
  ///
  /// Returns the number of screens, or default value 1 if not connected or on failure
  Future<int> getScreenAmount() async {
    if (isConnected() == false) {
      return 1;
    }

    var screenAmount = await client!
        .run("grep -oP '(?<=DHCP_LG_FRAMES_MAX=).*' personavars.txt");

    return int.parse(utf8.decode(screenAmount));
  }

  /// Sends a KML file to the Liquid Galaxy system.
  ///
  /// [kml] is the KML content to send.
  Future<void> sendKml(String kml, {List<String> images = const []}) async {
    if (!isConnected()) {
      return;
    }

    try {
      for (String image in images) {
        await upload(image);
      }

      const fileName = 'upload.kml';

      final sftpClient = await client!.sftp();

      final remoteFile = await sftpClient.open('/var/www/html/$fileName',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.write |
              SftpFileOpenMode.truncate);

      // Convert KML string to a stream and write it directly
      final kmlBytes = Uint8List.fromList(kml.codeUnits);
      await remoteFile.write(Stream.value(kmlBytes).cast<Uint8List>());
      await remoteFile.close();
      await client!
          .execute('echo "http://$lgUrl/$fileName" > /var/www/html/kmls.txt');
    } catch (e) {
      print('Error during KML file upload: $e');
    }
  }

  /// Uploads a file to the Liquid Galaxy.
  ///
  /// requires the [filePath] of the file to upload.
  Future<void> upload(String filePath) async {
    if (!isConnected()) {
      return;
    }

    try {
      // Load file data from assets
      final ByteData data = await rootBundle.load(filePath);

      // Extract the file name from the provided filePath
      final fileName = filePath.split('/').last;

      final sftp = await client!.sftp();

      // Upload file directly from byte data
      final remoteFile = await sftp.open(
        '/var/www/html/$fileName',
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write,
      );

      // Convert ByteData to Uint8List and write it directly
      final uint8ListData = data.buffer.asUint8List();
      await remoteFile.write(Stream.value(uint8ListData).cast<Uint8List>());
      await remoteFile.close();
    } catch (e) {
      print('Error during file upload: $e');
    }
  }

  /// Sends a KML file from the assets folder to the Liquid Galaxy system.
  ///
  /// [assetPath] is the path to the KML file in the assets folder.
  Future<void> sendKmlFromAssets(String assetPath,
      {List<String> images = const []}) async {
    if (isConnected() == false) {
      return;
    }

    try {
      // Load the KML file content from the assets folder
      String kmlContent = await rootBundle.loadString(assetPath);

      // Send the KML content to the master
      await sendKml(kmlContent, images: images);
    } catch (e) {
      print(e);
    }
  }

  /// Sends a KML file to a specific slave screen.
  ///
  /// [screenNumber] is the screen number.
  /// [kml] is the KML content to send.
  Future<void> sendKMLToSlave(int screenNumber, String kml) async {
    if (isConnected() == false) {
      return;
    }

    try {
      await client!
          .execute("echo '$kml' > /var/www/html/kml/slave_$screenNumber.kml");
    } catch (e) {
      print(e);
    }
  }

  /// Gets the left screen number.
  int get leftScreen {
    return screenAmount ~/ 2 + 2;
  }

  /// Gets the right screen number.
  int get rightScreen {
    return screenAmount ~/ 2 + 1;
  }

  /// Gets the password from the shared preferences. Returns null if not found.
  Future<String?> get password async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lg_password');
  }

  /// Relaunches the Liquid Galaxy services.
  Future<void> relaunch() async {
    final String? pw = await password;

    if (isConnected() == false || pw == null) {
      return;
    }

    final user = client!.username;

    for (var i = screenAmount; i >= 1; i--) {
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
    if (isConnected() == false) {
      return;
    }
    String query =
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';

    for (var i = 2; i <= screenAmount; i++) {
      String blankKml = KMLMakers.generateBlank('slave_$i');
      query += " && echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
    }

    await client!.execute(query);

    if (keepLogos) {
      await showLogos();
    }
  }

  /// Display the logos on the last screen of the Liquid Galaxy.
  Future<void> showLogos() async {
    if (isConnected() == false) {
      return;
    }

    await sendKMLToSlave(
        leftScreen, KMLMakers.screenOverlayImage(logosUrl, 4032 / 4024));
  }

  /// Reboots the Liquid Galaxy system.
  Future<void> reboot() async {
    final String? pw = await password;
    if (isConnected() == false || pw == null) {
      return;
    }

    for (var i = screenAmount; i >= 1; i--) {
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
    final String? pw = await password;
    if (isConnected() == false || pw == null) {
      return;
    }

    const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
    const replace =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    final command =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    final clear =
        'echo $pw | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';

    for (var i = 2; i <= screenAmount; i++) {
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
    final String? pw = await password;
    if (isConnected() == false || pw == null) {
      return;
    }

    const search =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    const replace = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';

    final clear =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    for (var i = 2; i <= screenAmount; i++) {
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
    final String? pw = await password;
    if (isConnected() == false || pw == null) {
      return;
    }

    for (var i = screenAmount; i >= 1; i--) {
      try {
        await client!.execute(
            'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S poweroff"');
      } catch (e) {
        print(e);
      }
    }
  }

  /// Sets the planet to display on the Liquid Galaxy.
  ///
  /// The [planet] can be 'earth', 'mars', or 'moon'.
  Future<void> setPlanet(String planet) async {
    if (isConnected() == false ||
        planet.isEmpty ||
        (planet != 'earth' && planet != 'mars' && planet != 'moon')) {
      return;
    }

    try {
      await client!.execute('echo \'planet=$planet\' > /tmp/query.txt');
    } catch (e) {
      print(e);
    }
  }

  /// Flies to a specific location on the Liquid Galaxy.
  ///
  /// the [latitude] and [longitude] are the coordinates of the location.
  /// [zoom] is the zoom level and [tilt] and [bearing] are the angles.
  Future<void> flyTo(double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    if (isConnected() == false) {
      return;
    }
    await client!.execute(
        'echo "flytoview=${KMLMakers.lookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
  }
}
