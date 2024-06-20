import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/widget/custom_dialog.dart';

/// A [ServicesPage] widget for managing services related to the Liquid Galaxy system.
///
/// Those services include relaunching, clearing KMLs, rebooting, setting refresh.They are used for managing the system remotely.
class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  /// Displays a dialog indicating that the Liquid Galaxy is not connected.
  void showNotConnectedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomDialog(
          title: 'Error',
          content: 'The Liquid Galaxy is not connected.\nPlease connect to the rig and try again.',
          iconName: 'error',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: 'Services',
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildServiceButton(
                      context,
                      icon: 'relaunch',
                      text: 'LG\nRELAUNCH',
                      onPressed: () async {
                        if (await lgConnection.isConnected()) {
                          lgConnection.relaunch();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                title: 'Reboot',
                                content: 'The relaunch command has been sent.\nThe Liquid Galaxy will relaunch in a few seconds.',
                                iconName: 'relaunch',
                              );
                            },
                          );
                        } else {
                          showNotConnectedDialog(context);
                        }
                      },
                    ),
                    _buildServiceButton(
                      context,
                      icon: 'clear',
                      text: 'CLEAR\nKML',
                      onPressed: () async {
                        if (await lgConnection.isConnected()) {
                          lgConnection.clearKml();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                title: 'Clear KML',
                                content: 'The Clear KML command has been sent to the Liquid Galaxy.\nThe KMLs will be cleared in a few seconds.',
                                iconName: 'clear',
                              );
                            },
                          );
                        } else {
                          showNotConnectedDialog(context);
                        }
                      },
                    ),
                    _buildServiceButton(
                      context,
                      icon: 'reboot',
                      text: 'LG\nREBOOT',
                      onPressed: () async {
                        if (await lgConnection.isConnected()) {
                          lgConnection.reboot();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                title: 'Reboot',
                                content: 'The reboot command has been sent.\nThe Liquid Galaxy will reboot in a few seconds.',
                                iconName: 'reboot',
                              );
                            },
                          );
                        } else {
                          showNotConnectedDialog(context);
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildServiceButton(
                      context,
                      icon: 'setrefresh',
                      text: 'SET\nREFRESH',
                      onPressed: () async {
                        if (await lgConnection.isConnected()) {
                          lgConnection.setRefresh();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                title: 'Set Refresh',
                                content: 'The Set Refresh command has been sent.\nThe Liquid Galaxy will set refresh and reboot in a few seconds.',
                                iconName: 'setrefresh',
                              );
                            },
                          );
                        } else {
                          showNotConnectedDialog(context);
                        }
                      },
                    ),
                    _buildServiceButton(
                      context,
                      icon: 'resetrefresh',
                      text: 'RESET\nREFRESH',
                      onPressed: () async {
                        if (await lgConnection.isConnected()) {
                          lgConnection.resetRefresh();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                title: 'Reset Refresh',
                                content: 'The Reset Refresh command has been sent.\nThe Liquid Galaxy will reset the refresh and reboot in a few seconds.',
                                iconName: 'resetrefresh',
                              );
                            },
                          );
                        } else {
                          showNotConnectedDialog(context);
                        }
                      },
                    ),
                    _buildServiceButton(
                      context,
                      icon: 'shutdown',
                      text: 'LG\nSHUTDOWN',
                      onPressed: () async {
                        if (await lgConnection.isConnected()) {
                          lgConnection.shutdown();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomDialog(
                                title: 'Shutdown',
                                content: 'The shutdown command has been sent.\nThe Liquid Galaxy will shutdown in a few seconds.',
                                iconName: 'shutdown',
                              );
                            },
                          );
                        } else {
                          showNotConnectedDialog(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a service button for the services page.
  ///
  /// [context] is the build context.
  /// [icon] is the name of the icon to display.
  /// [text] is the text to display on the button.
  /// [onPressed] is the function to call when the button is pressed.
  Widget _buildServiceButton(BuildContext context,
      {required String icon,
        required String text,
        required VoidCallback onPressed}) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Button(
        icon: CustomIcon(
          name: icon,
          size: 90,
          color: backgroundColor,
        ),
        text: text,
        color: secondaryColor,
        multiLine: true,
        bold: true,
        borderRadius: BorderRadius.circular(borderRadius),
        onPressed: onPressed,
      ),
    );
  }
}
