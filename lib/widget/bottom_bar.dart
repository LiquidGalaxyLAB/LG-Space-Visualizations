import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/led_status.dart';
import 'package:showcaseview/showcaseview.dart';

/// Global keys for the showcase of the [BottomBar] widget
GlobalKey? oneBottomBar;
GlobalKey? twoBottomBar;
GlobalKey? threeBottomBar;
GlobalKey? fourBottomBar;
GlobalKey? fiveBottomBar;

/// Bottom navigation bar with various buttons and a status indicator.
///
/// The [BottomBar] contains buttons for navigating to the home, settings, service, and info pages,
/// with a LED status indicator. It provides a common bottom navigation interface across the application.
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  /// The showcase keys
  final GlobalKey _oneBottomBar = GlobalKey();
  final GlobalKey _twoBottomBar = GlobalKey();
  final GlobalKey _threeBottomBar = GlobalKey();
  final GlobalKey _fourBottomBar = GlobalKey();
  final GlobalKey _fiveBottomBar = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    oneBottomBar = _oneBottomBar;
    twoBottomBar = _twoBottomBar;
    threeBottomBar = _threeBottomBar;
    fourBottomBar = _fourBottomBar;
    fiveBottomBar = _fiveBottomBar;

    return Container(
      margin: EdgeInsets.only(
          bottom: spaceBetweenWidgets,
          left: spaceBetweenWidgets,
          right: spaceBetweenWidgets),
      height: barHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
      ),
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Showcase(
                  key: fiveBottomBar!,
                  targetBorderRadius: BorderRadius.circular(borderRadius),
                  title: fiveShowcaseBottomBarTitle,
                  description: fiveShowcaseBottomBarDescription,
                  child: Button(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: secondaryColor,
                      icon: CustomIcon(
                        name: 'home',
                        size: 35,
                        color: backgroundColor,
                      ),
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, top: 8, bottom: 8),
                      onPressed: () {
                        // Navigate to home only if the current route is not home ('/')
                        if (currentRoute != '/home') {
                          Navigator.pushNamed(context, '/home');
                        }
                      })),
              const Spacer(),
              Showcase(
                  key: oneBottomBar!,
                  targetBorderRadius: BorderRadius.circular(borderRadius),
                  title: oneShowcaseBottomBarTitle,
                  description: oneShowcaseBottomBarDescription,
                  child: Button(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(0),
                      icon: CustomIcon(
                        name: "settings",
                        color: secondaryColor,
                        size: 40,
                      ),
                      onPressed: () {
                        // Navigate to settings only if the current route is not settings ('/settings')
                        if (currentRoute != '/settings') {
                          Navigator.pushNamed(context, '/settings');
                        }
                      })),
              Container(width: 35),
              Showcase(
                  key: twoBottomBar!,
                  targetBorderRadius: BorderRadius.circular(borderRadius),
                  title: twoShowcaseBottomBarTitle,
                  description: twoShowcaseBottomBarDescription,
                  child: Button(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(0),
                      icon: CustomIcon(
                        name: "services",
                        color: secondaryColor,
                        size: 40,
                      ),
                      onPressed: () {
                        // Navigate to service only if the current route is not service ('/service')
                        if (currentRoute != '/services') {
                          Navigator.pushNamed(context, '/services');
                        }
                      })),
              Container(width: 35),
              Showcase(
                  key: threeBottomBar!,
                  targetBorderRadius: BorderRadius.circular(borderRadius),
                  title: threeShowcaseBottomBarTitle,
                  description: threeShowcaseBottomBarDescription,
                  child: Button(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(0),
                      icon: CustomIcon(
                        name: "info",
                        color: secondaryColor,
                        size: 40,
                      ),
                      onPressed: () {
                        // Navigate to info only if the current route is not info ('/info')
                        if (currentRoute != '/info') {
                          Navigator.pushNamed(context, '/info');
                        }
                      })),
              Container(width: 40),
              Showcase(
                  key: fourBottomBar!,
                  targetShapeBorder: const CircleBorder(),
                  title: fourShowcaseBottomBarTitle,
                  description: fourShowcaseBottomBarDescription,
                  child: FutureBuilder<bool>(
                    future: lgConnection.isConnected(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return LedStatus(status: snapshot.data!, size: 35);
                      } else {
                        return const LedStatus(
                            status: false, size: 35, enable: false);
                      }
                    },
                  )),
            ],
          )),
    );
  }
}
