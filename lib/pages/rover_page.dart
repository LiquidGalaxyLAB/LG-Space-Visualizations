import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/kml/ballon_maker.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/info_box.dart';
import 'package:lg_space_visualizations/widget/map.dart';
import 'package:lg_space_visualizations/widget/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

/// [RoverPage] is a stateful widget that displays information about the Perseverance Rover.
///
/// It includes a 3D model of the rover, buttons to inspect the rover and see its cameras.
class RoverPage extends StatefulWidget {
  const RoverPage({super.key});

  @override
  _RoverPageState createState() => _RoverPageState();
}

class _RoverPageState extends State<RoverPage> {
  /// The showcase keys
  final GlobalKey _oneShowCase = GlobalKey();
  final GlobalKey _twoShowCase = GlobalKey();
  final GlobalKey _threeShowCase = GlobalKey();
  final GlobalKey _fourShowCase = GlobalKey();
  final GlobalKey _fiveShowCase = GlobalKey();
  final GlobalKey _sixShowCase = GlobalKey();

  @override
  void initState() {
    super.initState();
    showVisualizations();

    // Show the showcase tutorial if it's the first time the user opens the page
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('showcaseRoverPage') ?? true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowCaseWidget.of(context).startShowCase([
            _oneShowCase,
            _twoShowCase,
            _threeShowCase,
            oneBottomBarMapShowcase!,
            _fourShowCase,
            _fiveShowCase,
            _sixShowCase,
          ]);
          prefs.setBool('showcaseRoverPage', false);
        });
      }
    });
  }

  @override
  void dispose() {
    /// Clear the KML when the page is disposed keeping the logos.
    lgConnection.clearKml(keepLogos: true);
    super.dispose();
  }

  /// Display the KML visualizations of the rover.
  void showVisualizations() async {
    // Set the planet to Mars
    await lgConnection.setPlanet('mars');

    // Display a balloon with information about the Perseverance rover
    await lgConnection.sendKMLToSlave(lgConnection.rightScreen,
        BalloonMaker.generatePerseveranceRoverBalloon());

    // Send the KML file of the rover's path to the LG
    lgConnection.sendKmlFromAssets('assets/kmls/rover_path.kml',
        images: ['assets/images/rover_icon.png']);
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(title: "Perseverance Rover", children: [
      Expanded(
        flex: 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(spaceBetweenWidgets / 2),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Showcase(
                        key: _twoShowCase,
                        targetBorderRadius: BorderRadius.circular(borderRadius),
                        title: twoShowcaseRoverPageTitle,
                        description: twoShowcaseRoverPageDescription,
                        child: const ViewModel(
                          model: 'assets/models/perseverance_rover.glb',
                          backgroundImage: 'assets/images/model_background.png',
                          alt: 'perseverance rover',
                          cameraOrbit: '-10deg 78deg 5.5m',
                        ))),
                SizedBox(height: spaceBetweenWidgets - 5),
                Showcase(
                    key: _fourShowCase,
                    targetBorderRadius: BorderRadius.circular(borderRadius),
                    title: fourShowcaseRoverPageTitle,
                    description: fourShowcaseRoverPageDescription,
                    child: Button(
                      color: secondaryColor,
                      center: false,
                      text: 'Inspect Rover',
                      padding:
                          const EdgeInsets.only(left: 25, top: 5, bottom: 5),
                      borderRadius: BorderRadius.circular(borderRadius),
                      icon: CustomIcon(
                          name: 'mechanic', size: 40, color: backgroundColor),
                      onPressed: () {
                        setState(() {
                          Navigator.pushNamed(context, '/web', arguments: {
                            'url': inspectRoverUrl,
                            'title': 'Inspect Perseverance Rover'
                          });
                        });
                      },
                    )),
                SizedBox(height: spaceBetweenWidgets / 2),
                Showcase(
                    key: _fiveShowCase,
                    targetBorderRadius: BorderRadius.circular(borderRadius),
                    title: fiveShowcaseRoverPageTitle,
                    description: fiveShowcaseRoverPageDescription,
                    child: Button(
                      color: secondaryColor,
                      center: false,
                      text: 'See rover cameras',
                      padding:
                          const EdgeInsets.only(left: 25, top: 5, bottom: 5),
                      borderRadius: BorderRadius.circular(borderRadius),
                      icon: CustomIcon(
                          name: 'cameras', size: 40, color: backgroundColor),
                      onPressed: () {
                        setState(() {
                          Navigator.pushNamed(context, '/cameras');
                        });
                      },
                    )),
                SizedBox(height: spaceBetweenWidgets / 2),
                Showcase(
                    key: _sixShowCase,
                    targetBorderRadius: BorderRadius.circular(borderRadius),
                    title: sixShowcaseRoverPageTitle,
                    description: sixShowcaseRoverPageDescription,
                    child: Button(
                      center: false,
                      color: secondaryColor,
                      text: 'Learn more about the rover',
                      padding: const EdgeInsets.only(left: 15),
                      borderRadius: BorderRadius.circular(borderRadius),
                      icon: CustomIcon(
                          name: 'read', size: 50, color: backgroundColor),
                      onPressed: () {
                        setState(() {
                          Navigator.pushNamed(context, '/web', arguments: {
                            'url': roverUrl,
                            'title': 'Perseverance Rover'
                          });
                        });
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
      SizedBox(width: spaceBetweenWidgets),
      Expanded(
        flex: 7,
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
                bottom: spaceBetweenWidgets),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Showcase(
                    key: _oneShowCase,
                    targetBorderRadius: BorderRadius.circular(borderRadius),
                    title: oneShowcaseRoverPageTitle,
                    description: oneShowcaseRoverPageDescription,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "About",
                            style: middleTitle,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '$roverIntroText $roverDescriptionText',
                            style: smallText,
                          ),
                        ])),
                SizedBox(height: spaceBetweenWidgets / 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoBox(text: '1025 kg', subText: 'Mass'),
                    InfoBox(text: '10x9x7 m', subText: 'Dimensions'),
                    InfoBox(text: '2 GB', subText: 'Flash Memory'),
                    InfoBox(text: '200 MHz', subText: 'Processor Speed'),
                    InfoBox(text: '4.8 kg', subText: 'Plutonium Dioxide Fuel'),
                    InfoBox(text: '152 m/h', subText: 'Top Speed')
                  ],
                ),
                SizedBox(height: spaceBetweenWidgets / 4),
                Expanded(
                    child: Showcase(
                        key: _threeShowCase,
                        targetBorderRadius: BorderRadius.circular(borderRadius),
                        title: threeShowcaseRoverPageTitle,
                        description: threeShowcaseRoverPageDescription,
                        child: Map(
                            latitude: mapMarsCenterLat,
                            longitude: mapMarsCenterLong,
                            zoom: defaultMarsMapZoom,
                            tilt: defaultMarsMapTilt,
                            bearing: defaultMarsMapBearing,
                            minMaxZoomPreference:
                                const MinMaxZoomPreference(11, 14),
                            bounds: roverLandingBounds,
                            boost: defaultMarsMapBoost,
                            orbitTilt: defaultMarsOrbitTilt,
                            orbitRange: defaultMarsOrbitRange,
                            kmlName: 'Rover'))),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
