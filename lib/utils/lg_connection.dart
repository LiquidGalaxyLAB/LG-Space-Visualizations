import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/services.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/kml/kml_makers.dart';
import 'package:lg_space_visualizations/utils/kml/orbit_kml.dart';
import 'package:lg_space_visualizations/utils/ssh_connection.dart';

/// Global instance of [LGConnection].
LGConnection lgConnection = LGConnection();

/// Manages a connection to the Liquid Galaxy system using SSH.
class LGConnection {
  /// Creates an [LGConnection] instance.
  LGConnection();

  /// SSH class for managing the connection.
  SSHConnection sshConnection = SSHConnection();

  /// Gets the left screen number.
  int get leftScreen => sshConnection.leftScreen;

  /// Gets the right screen number.
  int get rightScreen => sshConnection.rightScreen;

  /// Gets the screen amount.
  int get screenAmount => sshConnection.screenAmount;

  /// Returns the status of the SSH connection.
  bool isConnected() {
    return sshConnection.isConnected();
  }

  /// Connects to the Liquid Galaxy system.
  Future<bool> connect() async {
    bool status = await sshConnection.connect();

    // If the connection is successful, show the logos
    if (status) {
      await showLogos();
    }

    return status;
  }

  /// Disconnects from the Liquid Galaxy system.
  void disconnect() {
    sshConnection.disconnect();
  }

  /// Sends a KML to a specific screen on the Liquid Galaxy system.
  Future<void> sendKMLToSlave(int screen, String kml) async {
    await sshConnection.sendKMLToSlave(screen, kml);
  }

  /// Sends a KML file from the assets folder to the Liquid Galaxy system.
  ///
  /// [assetPath] is the path to the KML file in the assets folder.
  Future<void> sendKmlFromAssets(String assetPath,
      {List<String> images = const []}) async {
    // Load the KML file content from the assets folder
    final kml = await rootBundle.loadString(assetPath);

    // Send the KML content to the master
    await sshConnection.sendKml(kml, images: images);
  }

  /// Relaunches the Liquid Galaxy services.
  Future<void> relaunch() async {
    final String? pw = await sshConnection.password;

    if (sshConnection.isConnected() == false || pw == null) {
      return;
    }

    final user = sshConnection.username;

    for (var i = sshConnection.screenAmount; i >= 1; i--) {
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
      await sshConnection
          .sendCommand('"/home/$user/bin/lg-relaunch" > /home/$user/log.txt');
      await sshConnection.sendCommand(relaunchCommand);
    }
  }

  /// Clears the KML files from the Liquid Galaxy system.
  ///
  /// [keepLogos] indicates whether to keep the logo overlays.
  Future<void> clearKml({bool keepLogos = false}) async {
    if (sshConnection.isConnected() == false) {
      return;
    }
    String query =
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';

    for (var i = 2; i <= sshConnection.screenAmount; i++) {
      String blankKml = KMLMakers.generateBlank('slave_$i');
      query += " && echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
    }

    await sshConnection.sendCommand(query);

    if (keepLogos) {
      await showLogos();
    }
  }

  /// Display the logos on the last screen of the Liquid Galaxy.
  Future<void> showLogos() async {
    if (sshConnection.isConnected() == false) {
      return;
    }

    await sshConnection.sendKMLToSlave(sshConnection.leftScreen,
        KMLMakers.screenOverlayImage(logosUrl, 4032 / 4024));
  }

  /// Reboots the Liquid Galaxy system.
  Future<void> reboot() async {
    final String? pw = await sshConnection.password;
    if (sshConnection.isConnected() == false || pw == null) {
      return;
    }

    for (var i = sshConnection.screenAmount; i >= 1; i--) {
      await sshConnection.sendCommand(
          'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"');
    }
  }

  /// Shuts down the Liquid Galaxy system.
  Future<void> shutdown() async {
    final String? pw = await sshConnection.password;
    if (sshConnection.isConnected() == false || pw == null) {
      return;
    }

    for (var i = sshConnection.screenAmount; i >= 1; i--) {
      await sshConnection.sendCommand(
          'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S poweroff"');
    }
  }

  /// Sets the planet to display on the Liquid Galaxy.
  ///
  /// The [planet] can be 'earth', 'mars', or 'moon'.
  Future<void> setPlanet(String planet) async {
    if (sshConnection.isConnected() == false ||
        planet.isEmpty ||
        (planet != 'earth' && planet != 'mars' && planet != 'moon')) {
      return;
    }

    await sshConnection.sendCommand('echo \'planet=$planet\' > /tmp/query.txt');
  }

  /// Flies to a specific location on the Liquid Galaxy.
  ///
  /// the [latitude] and [longitude] are the coordinates of the location.
  /// [zoom] is the zoom level and [tilt] and [bearing] are the angles.
  Future<void> flyTo(double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    if (sshConnection.isConnected() == false) {
      return;
    }
    await sshConnection.sendCommand(
        'echo "flytoview=${KMLMakers.lookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
  }

  /// Builds an orbit animation around a specific latitude and longitude.
  ///
  /// This method computes an orbit animation based on provided [latitude], [longitude], [zoom] level,
  /// [tilt], and [bearing].
  ///
  /// Upon creating the orbit, it automatically initiates the orbit by calling `startOrbit`.
  Future<void> buildOrbit(double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    // Build the orbit KML
    final orbit = OrbitKml.buildOrbit(
        OrbitKml.tag(latitude, longitude, zoom, tilt, bearing));
    // Start the orbit
    await startOrbit(orbit);
  }

  /// Starts the orbit animation on the Liquid Galaxy.
  ///
  /// This method sends a KML file representing the orbit to the Liquid Galaxy and starts
  /// the orbit animation.
  ///
  /// [tourKml] is the KML content defining the orbit.
  Future<void> startOrbit(String tourKml) async {
    if (!sshConnection.isConnected()) {
      return;
    }

    const fileName = 'Orbit.kml';

    final sftp = await sshConnection.sftp;

    // Open a remote file for writing
    final remoteFile = await sftp.open('/var/www/html/$fileName',
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.write |
            SftpFileOpenMode.truncate);

    // Convert KML string to a stream
    final kmlStreamBytes = Stream.value(Uint8List.fromList(tourKml.codeUnits));

    // Write the KML content to the remote file
    await remoteFile.write(kmlStreamBytes);

    await remoteFile.close();

    // Prepare the orbit
    await sshConnection.sendCommand(
        "echo '\nhttp://lg1:81/$fileName' >> /var/www/html/kmls.txt");

    await Future.delayed(const Duration(seconds: 1));

    // Start the orbit
    await sshConnection.sendCommand('echo "playtour=Orbit" > /tmp/query.txt');
  }

  /// Stops any currently playing orbit animation on the Liquid Galaxy.
  Future<void> stopOrbit() async {
    if (!sshConnection.isConnected()) {
      return;
    }

    await sshConnection.sendCommand('echo "exittour=true" > /tmp/query.txt');
  }

  /// Displays an image on the Liquid Galaxy system using Chromium.
  ///
  /// Requires `display_images_service` to be installed on the Liquid Galaxy system.
  ///
  /// [imgUrl] is the URL of the image to be displayed.
  Future<void> displayImageOnLG(String imgUrl) async {
    final String? pw = await sshConnection.password;

    if (!sshConnection.isConnected() || pw == null) {
      return;
    }

    await sshConnection.sendCommand(
        'bash display_images_service/scripts/open.sh $pw $imgUrl ${sshConnection.screenAmount}');
  }

  /// Closes the image displayed on the Liquid Galaxy system.
  ///
  /// Requires `display_images_service` to be installed on the Liquid Galaxy system.
  Future<void> closeImageOnLG() async {
    final String? pw = await sshConnection.password;

    if (!sshConnection.isConnected() || pw == null) {
      return;
    }

    await sshConnection
        .sendCommand('bash display_images_service/scripts/close.sh $pw');
  }
}
