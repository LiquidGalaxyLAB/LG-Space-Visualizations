import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_dialog.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';

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
        return CustomDialog(
          title: errorTitle,
          content: notConnectedMessage,
          iconName: 'error',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: titleServices,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: backgroundColor,
            ),
            padding: EdgeInsets.only(
              top: spaceBetweenWidgets,
              left: spaceBetweenWidgets,
              right: spaceBetweenWidgets,
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
                      text: relaunchTitle,
                      onPressed: () async {
                        if (lgConnection.isConnected()) {
                          lgConnection.relaunch();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: relaunchMessageTitle,
                                content: relaunchSuccessMessage,
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
                      text: clearKmlTitle,
                      onPressed: () async {
                        if (lgConnection.isConnected()) {
                          lgConnection.clearKml(keepLogos: true);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: clearKmlMessageTitle,
                                content: clearKmlSuccessMessage,
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
                      text: rebootTitle,
                      onPressed: () async {
                        if (lgConnection.isConnected()) {
                          lgConnection.reboot();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: rebootMessageTitle,
                                content: rebootSuccessMessage,
                                iconName: 'reboot',
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
                      icon: 'see',
                      text: showLogosTitle,
                      onPressed: () async {
                        if (lgConnection.isConnected()) {
                          lgConnection.showLogos();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: showLogosMessageTitle,
                                content: showLogosSuccessMessage,
                                iconName: 'see',
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
                      text: setRefreshTitle,
                      onPressed: () async {
                        if (lgConnection.isConnected()) {
                          lgConnection.setRefresh();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: setRefreshMessageTitle,
                                content: setRefreshSuccessMessage,
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
                      text: setRefreshTitle,
                      onPressed: () async {
                        if (lgConnection.isConnected()) {
                          lgConnection.resetRefresh();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: resetRefreshMessageTitle,
                                content: resetRefreshSuccessMessage,
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
                      text: shutdownTitle,
                      onPressed: () async {
                        if (lgConnection.isConnected()) {
                          lgConnection.shutdown();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: shutdownMessageTitle,
                                content: shutdownSuccessMessage,
                                iconName: 'shutdown',
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
                      icon: 'hide',
                      text: hideLogosTitle,
                      onPressed: () async {
                        if (lgConnection.isConnected()) {
                          lgConnection.clearKml(keepLogos: false);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: hideLogosMessageTitle,
                                content: hideLogosSuccessMessage,
                                iconName: 'hide',
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
