import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/nasa_api.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
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
    apiKeyController.text = prefs.getString('nasa_api_key_unchecked') ?? '';

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
      title: settingsTitle,
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
                    settingsSubtitle,
                    style: middleTitle,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: spaceBetweenWidgets),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildRow(context,
                            icon: 'user',
                            label: usernameLabel,
                            controller: usernameController,
                            hintText: usernameHint,
                            inputType: TextInputType.text,
                            id: 'lg_username',
                            dialogTitle: usernameLabel,
                            dialogContent: usernameDialogContent),
                        SizedBox(height: spaceBetweenWidgets),
                        _buildRow(context,
                            icon: 'ip',
                            label: ipLabel,
                            controller: ipController,
                            hintText: ipHint,
                            inputType: TextInputType.number,
                            id: 'lg_ip',
                            dialogTitle: ipLabel,
                            dialogContent: ipDialogContent),
                        SizedBox(height: spaceBetweenWidgets),
                        _buildRow(context,
                            icon: 'ethernet',
                            label: portLabel,
                            controller: portController,
                            hintText: portHint,
                            inputType: TextInputType.number,
                            id: 'lg_port',
                            dialogTitle: 'Port',
                            dialogContent: portDialogContent),
                        SizedBox(height: spaceBetweenWidgets),
                        _buildRow(context,
                            icon: 'locker',
                            label: passwordLabel,
                            controller: passwordController,
                            hintText: passwordHint,
                            inputType: TextInputType.text,
                            id: 'lg_password',
                            secure: true,
                            dialogTitle: passwordLabel,
                            dialogContent: passwordDialogContent),
                        SizedBox(height: spaceBetweenWidgets),
                        _buildRow(context,
                            icon: 'api',
                            label: apiLabel,
                            controller: apiKeyController,
                            hintText: apiHint,
                            inputType: TextInputType.text,
                            id: 'nasa_api_key_unchecked',
                            secure: true,
                            dialogTitle: apiLabel,
                            dialogContent: apiDialogContent,
                            onSubmitted: (key) async {
                          if (key.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.remove('nasa_api_key');
                                });
                                return CustomDialog(
                                  title: apiSaveSuccessMessage,
                                  content: defaultKeyApiMessage,
                                  iconName: 'api',
                                );
                              },
                            );
                          } else if (await NasaApi.isApiKeyValid(key)) {
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setString('nasa_api_key', key);
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  title: apiSaveSuccessMessage,
                                  content: customApiSavedMessage,
                                  iconName: 'api',
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  title: apiInvalidTitle,
                                  content: apiInvalidMessage,
                                  iconName: 'error',
                                );
                              },
                            );
                          }
                        }),
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
      required String dialogContent,
      Function(String)? onSubmitted}) {
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
          onSubmitted: onSubmitted,
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
        SizedBox(
          height: 50,
          child: Button(
            icon: CustomIcon(
              name: 'connect',
              size: 40,
              color: backgroundColor,
            ),
            text: connectButton,
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
                    return CustomDialog(
                      title: missingFieldsTitle,
                      content: missingFieldsMessage,
                      iconName: 'error',
                    );
                  },
                );
              } else {
                prefs.setString('lg_username', usernameController.text);
                prefs.setString('lg_ip', ipController.text);
                prefs.setInt('lg_port', int.parse(portController.text));
                prefs.setString('lg_password', passwordController.text);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FutureBuilder(
                        future: lgConnection.connect(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data ?? false) {
                              return CustomDialog(
                                title: connectButton,
                                content: connectSuccessMessage,
                                iconName: 'connect',
                              );
                            } else {
                              return CustomDialog(
                                title: connectErrorTitle,
                                content: connectError,
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
            text: disconnectButton,
            color: secondaryColor,
            borderRadius: BorderRadius.circular(borderRadius),
            onPressed: () async {
              if (lgConnection.isConnected()) {
                lgConnection.disconnect();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: disconnectButton,
                      content: disconnectSuccessMessage,
                      iconName: 'disconnect',
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: alreadyDisconnectedTitle,
                      content: alreadyDisconnectedMessage,
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
