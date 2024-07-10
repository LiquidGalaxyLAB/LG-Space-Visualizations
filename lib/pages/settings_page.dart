import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/input.dart';
import 'package:lg_space_visualizations/widget/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';

/// A [SettingsPage] widget for configuring settings related to the Liquid Galaxy connection.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// Controller for the username input field.
  final TextEditingController usernameController = TextEditingController();

  /// Controller for the IP address input field.
  final TextEditingController ipController = TextEditingController();

  /// Controller for the port input field.
  final TextEditingController portController = TextEditingController();

  /// Controller for the password input field.
  final TextEditingController passwordController = TextEditingController();

  /// Controller for the NASA API key input field.
  final TextEditingController apiKeyController = TextEditingController();

  /// Indicates whether the fields have been loaded with saved preferences data.
  bool loaded = false;

  /// Updates the input fields with saved preferences data.
  updateFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    usernameController.text = prefs.getString('lg_username') ?? '';
    ipController.text = prefs.getString('lg_ip') ?? '';
    portController.text =
        prefs.containsKey('lg_port') ? prefs.getInt('lg_port').toString() : '';
    passwordController.text = prefs.getString('lg_password') ?? '';
    apiKeyController.text = prefs.getString('nasa_key') ?? '';

    loaded = true;
  }

  @override
  void initState() {
    super.initState();
    updateFields();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return TemplatePage(
      title: 'Settings',
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: backgroundColor,
            ),
            padding: EdgeInsets.only(
              top: spaceBetweenWidgets,
              left: 2 * spaceBetweenWidgets,
              right: 2 * spaceBetweenWidgets,
              bottom: spaceBetweenWidgets,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Connect to the Liquid Galaxy',
                    style: middleTitle,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: spaceBetweenWidgets),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildRow(
                          context,
                          icon: 'user',
                          label: 'Username',
                          controller: usernameController,
                          hintText: 'Enter Liquid Galaxy username',
                          inputType: TextInputType.text,
                          id: 'lg_username',
                          dialogTitle: 'Username',
                          dialogContent:
                              'Enter the username of the Liquid Galaxy. This is the username\nof the master computer that is running the Liquid Galaxy.',
                        ),
                        SizedBox(height: spaceBetweenWidgets),
                        _buildRow(
                          context,
                          icon: 'ip',
                          label: 'IP',
                          controller: ipController,
                          hintText: 'Enter Liquid Galaxy IP address',
                          inputType: TextInputType.number,
                          id: 'lg_ip',
                          dialogTitle: 'IP Address',
                          dialogContent:
                              'Enter the IP address of the Liquid Galaxy. This is the IP\nof the master computer running Liquid Galaxy.',
                        ),
                        SizedBox(height: spaceBetweenWidgets),
                        _buildRow(
                          context,
                          icon: 'ethernet',
                          label: 'Port',
                          controller: portController,
                          hintText: 'Enter Liquid Galaxy Port',
                          inputType: TextInputType.number,
                          id: 'lg_port',
                          dialogTitle: 'Port',
                          dialogContent:
                              'Enter the port of the SSH service of the Liquid\nGalaxy master. Default is 22',
                        ),
                        SizedBox(height: spaceBetweenWidgets),
                        _buildRow(
                          context,
                          icon: 'locker',
                          label: 'Password',
                          controller: passwordController,
                          hintText: 'Enter password',
                          inputType: TextInputType.text,
                          id: 'lg_password',
                          secure: true,
                          dialogTitle: 'Password',
                          dialogContent:
                              'Enter the password of the Liquid Galaxy. This is the password\nof the master computer running Liquid Galaxy.',
                        ),
                        SizedBox(height: spaceBetweenWidgets),
                        _buildRow(
                          context,
                          icon: 'api',
                          label: 'Nasa API Key',
                          controller: apiKeyController,
                          hintText: 'Enter Nasa API Key (optional)',
                          inputType: TextInputType.text,
                          id: 'nasa_key',
                          secure: true,
                          dialogTitle: 'Nasa API Key',
                          dialogContent:
                              'Enter the NASA API key. This is optional and is used to\nfetch data for the MARS 2020 section.',
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isKeyboardVisible) _buildButtons(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a row containing an icon, label, input field, and info button.
  Widget _buildRow(BuildContext context,
      {required String icon,
      required String label,
      required TextEditingController controller,
      required String hintText,
      required TextInputType inputType,
      required String id,
      bool secure = false,
      required String dialogTitle,
      required String dialogContent}) {
    return Row(
      children: [
        CustomIcon(name: icon, size: 50, color: secondaryColor),
        SizedBox(width: spaceBetweenWidgets),
        SizedBox(
          width: 160,
          child: Text(label, style: bigText, textAlign: TextAlign.left),
        ),
        Input(
          controller: controller,
          hintText: hintText,
          inputType: inputType,
          id: id,
          secure: secure,
        ),
        SizedBox(width: spaceBetweenWidgets),
        Button(
          icon: CustomIcon(name: 'info', size: 40, color: secondaryColor),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    title: dialogTitle,
                    content: dialogContent,
                    iconName: 'info');
              },
            );
          },
        ),
      ],
    );
  }

  /// Builds the connect and disconnect buttons.
  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        SizedBox(
          height: 50,
          child: Button(
            icon: CustomIcon(
              name: 'connect',
              size: 40,
              color: backgroundColor,
            ),
            text: 'Connect',
            color: secondaryColor,
            borderRadius: BorderRadius.circular(borderRadius),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              if (usernameController.text.isEmpty ||
                  ipController.text.isEmpty ||
                  portController.text.isEmpty ||
                  passwordController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialog(
                      title: 'Missing Fields',
                      content: 'Please fill in all the required fields.',
                      iconName: 'error',
                    );
                  },
                );
              } else {
                prefs.setString('lg_username', usernameController.text);
                prefs.setString('lg_ip', ipController.text);
                prefs.setInt('lg_port', int.parse(portController.text));
                prefs.setString('lg_password', passwordController.text);
                // TODO encrypt api key
                prefs.setString('nasa_key', apiKeyController.text);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FutureBuilder(
                        future: lgConnection.connect(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data ?? false) {
                              return const CustomDialog(
                                title: 'Connection successful',
                                content:
                                    'Liquid Galaxy connected successfully.',
                                iconName: 'connect',
                              );
                            } else {
                              return const CustomDialog(
                                title: 'Connection Error',
                                content:
                                    'An error occurred while connecting.\nPlease check the Liquid Galaxy status\nand verify the connection settings.',
                                iconName: 'error',
                              );
                            }
                          } else {
                            return Center(
                                child: SizedBox(
                                    width: 100.0,
                                    height: 100.0,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 8,
                                        color: backgroundColor)));
                          }
                        });
                  },
                );
              }
            },
          ),
        ),
        SizedBox(height: spaceBetweenWidgets / 1.5),
        SizedBox(
          height: 50,
          child: Button(
            icon: CustomIcon(
              name: 'disconnect',
              size: 40,
              color: backgroundColor,
            ),
            text: 'Disconnect',
            color: secondaryColor,
            borderRadius: BorderRadius.circular(borderRadius),
            onPressed: () async {
              if (lgConnection.isConnected()) {
                lgConnection.disconnect();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialog(
                      title: 'Disconnected',
                      content: 'Liquid Galaxy disconnected successfully.',
                      iconName: 'disconnect',
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialog(
                      title: 'Not Connected',
                      content: 'Liquid Galaxy is already disconnected.',
                      iconName: 'error',
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
