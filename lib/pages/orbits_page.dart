import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/info_box.dart';
import 'package:lg_space_visualizations/widget/orbit_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

/// A page that displays a grid of orbits with an general overview of orbits.
class OrbitsPage extends StatefulWidget {
  const OrbitsPage({super.key});

  @override
  _OrbitsPageState createState() => _OrbitsPageState();
}

class _OrbitsPageState extends State<OrbitsPage> {
  /// The showcase keys
  final GlobalKey _oneShowCase = GlobalKey();
  final GlobalKey _twoShowCase = GlobalKey();
  final GlobalKey _threeShowCase = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Set the Liquid Galaxy to Earth mode
    lgConnection.setPlanet('earth');

    // Show the showcase tutorial if it's the first time the user opens the page
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('showcaseOrbitsPage') ?? true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowCaseWidget.of(context)
              .startShowCase([_oneShowCase, _twoShowCase, _threeShowCase]);
          prefs.setBool('showcaseOrbitsPage', false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: orbitsTitle,
      children: [
        Expanded(
            flex: 3,
            child: Showcase(
              key: _oneShowCase,
              targetBorderRadius: BorderRadius.circular(borderRadius),
              title: oneShowcaseOrbitsPageTitle,
              description: oneShowcaseOrbitsPageDescription,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: backgroundColor,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: spaceBetweenWidgets,
                    right: spaceBetweenWidgets,
                    top: spaceBetweenWidgets / 2,
                    bottom: spaceBetweenWidgets,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        orbitsDescriptionTitle,
                        style: middleTitle,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        orbitsIntroText,
                        style: smallText,
                      ),
                      SizedBox(height: spaceBetweenWidgets),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InfoBox(
                            text: orbitsFirstDataValue,
                            subText: orbitsFirstDataText,
                          ),
                          InfoBox(
                            text: orbitsSecondDataValue,
                            subText: orbitsSecondDataText,
                          ),
                        ],
                      ),
                      SizedBox(height: spaceBetweenWidgets),
                      Text(
                        orbitsEndText,
                        style: smallText,
                      ),
                      const Spacer(),
                      Button(
                        center: false,
                        padding: const EdgeInsets.only(left: 15),
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(borderRadius),
                        icon: CustomIcon(
                          name: 'read',
                          size: 50,
                          color: backgroundColor,
                        ),
                        text: orbitsLearnMoreText,
                        onPressed: () {
                          setState(() {
                            Navigator.pushNamed(context, '/web', arguments: {
                              'url': orbitsUrl,
                              'title': orbitsTitle,
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )),
        SizedBox(width: spaceBetweenWidgets),
        Expanded(
            flex: 7,
            child: Showcase(
                key: _twoShowCase,
                targetBorderRadius: BorderRadius.circular(borderRadius),
                title: twoShowcaseOrbitsPageTitle,
                description: twoShowcaseOrbitsPageDescription,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orbits.length,
                    itemBuilder: (BuildContext context, int index) {
                      return index == 0
                          ? Showcase(
                              key: _threeShowCase,
                              targetBorderRadius:
                                  BorderRadius.circular(borderRadius),
                              title: threeShowcaseOrbitsPageTitle,
                              description: threeShowcaseOrbitsPageDescription,
                              child: OrbitBox(orbit: orbits[index]))
                          : OrbitBox(orbit: orbits[index]);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.064,
                      crossAxisSpacing: spaceBetweenWidgets,
                      mainAxisSpacing: spaceBetweenWidgets,
                    ),
                  ),
                ))),
      ],
    );
  }
}
