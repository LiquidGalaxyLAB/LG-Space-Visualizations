import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/services.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSHConnection {
  /// SSH client for managing the connection.
  late SSHClient client;

  /// Number of screens in the Liquid Galaxy system, default is 5.
  int screenAmount = 5;

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

  String get username {
    return client.username;
  }

  /// Returns the sftp client
  Future<SftpClient> get sftp => client.sftp();

  /// Checks if the SSH client is connected.
  ///
  /// Returns `true` if connected, `false` otherwise.
  bool isConnected() {
    return client.isClosed == false;
  }

  /// Disconnects the SSH client if connected.
  void disconnect() {
    if (isConnected()) {
      client.close();
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

      await client.authenticated;
      screenAmount = await getScreenAmount();
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

    var screenAmount = await client
        .run("grep -oP '(?<=DHCP_LG_FRAMES_MAX=).*' personavars.txt");

    return int.parse(utf8.decode(screenAmount));
  }

  /// Sends the [command] to the Liquid Galaxy.
  Future<SSHSession> sendCommand(String command) async {
    return await client.execute(command);
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

      final sftp = await client.sftp();

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

      final sftpClient = await sftp;

      final remoteFile = await sftpClient.open('/var/www/html/$fileName',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.write |
              SftpFileOpenMode.truncate);

      // Convert KML string to a stream and write it directly
      final kmlBytes = Uint8List.fromList(kml.codeUnits);
      await remoteFile.write(Stream.value(kmlBytes).cast<Uint8List>());
      await remoteFile.close();
      await sendCommand(
          'echo "http://$lgUrl/$fileName" > /var/www/html/kmls.txt');
    } catch (e) {
      print('Error during KML file upload: $e');
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
      await sendCommand(
          "echo '$kml' > /var/www/html/kml/slave_$screenNumber.kml");
    } catch (e) {
      print(e);
    }
  }
}
