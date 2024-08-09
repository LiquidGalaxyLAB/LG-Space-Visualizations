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

/// [DronePage] is a widget that displays information about the Ingenuity Drone.
///
/// It includes a 3D model of the rover, information about the drone, its flights, and specifications.
class DronePage extends StatefulWidget {
  const DronePage({super.key});

  @override
  _DronePageState createState() => _DronePageState();
}

class _DronePageState extends State<DronePage> {
  @override
  void initState() {
    super.initState();
    showVisualizations();
  }

  @override
  void dispose() {
    /// Clear the KML when the page is disposed keeping the logos.
    lgConnection.clearKml(keepLogos: true);
    super.dispose();
  }

  /// Display the KML visualizations of the drone.
  void showVisualizations() async {
    // Set the planet to Mars
    await lgConnection.setPlanet('mars');

    // Display a balloon with information about the Ingenuity Drone
    await lgConnection.sendKMLToSlave(lgConnection.rightScreen,
        BalloonMaker.generateIngenuityHelicopterBalloon());

    // Send the KML file of the drone's path to the LG
    await lgConnection.sendKmlFromAssets('assets/kmls/drone_path.kml',
        images: ['assets/images/drone_icon.png']);
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(title: droneTitle, children: [
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
                const ViewModel(
                  model: 'assets/models/ingenuity_drone.glb',
                  backgroundImage: 'assets/images/model_background.png',
                  alt: 'ingenuity drone',
                  cameraOrbit: '-10deg 78deg 2m',
                ),
                SizedBox(height: spaceBetweenWidgets - 5),
                Button(
                  color: secondaryColor,
                  center: false,
                  text: droneLearnMoreText,
                  padding: const EdgeInsets.only(left: 15),
                  borderRadius: BorderRadius.circular(borderRadius),
                  icon: CustomIcon(
                      name: 'read', size: 50, color: backgroundColor),
                  onPressed: () {
                    setState(() {
                      setState(() {
                        Navigator.pushNamed(context, '/web',
                            arguments: {'url': droneUrl, 'title': droneTitle});
                      });
                    });
                  },
                ),
                SizedBox(height: spaceBetweenWidgets / 2),
                Button(
                    color: secondaryColor,
                    center: false,
                    text: meetTheRoverText,
                    padding: const EdgeInsets.only(left: 15),
                    borderRadius: BorderRadius.circular(borderRadius),
                    icon: CustomIcon(
                        name: 'rover', size: 50, color: backgroundColor),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/rover');
                      });
                    }),
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
                top: spaceBetweenWidgets / 4,
                bottom: spaceBetweenWidgets),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titleDroneDescriptionText,
                  style: middleTitle,
                  textAlign: TextAlign.left,
                ),
                Text(droneIntroText, style: smallText),
                SizedBox(height: spaceBetweenWidgets / 4),
                Text(droneDescriptionText, style: smallText),
                SizedBox(height: spaceBetweenWidgets / 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoBox(
                        text: droneFirstDataValue,
                        subText: droneFirstDataText),
                    InfoBox(
                        text: droneSecondDataValue,
                        subText: droneSecondDataText),
                    InfoBox(
                        text: droneThirdDataValue,
                        subText: droneThirdDataText),
                    InfoBox(
                        text: droneFourthDataValue,
                        subText: droneFourthDataText),
                    InfoBox(
                        text: droneFifthDataValue,
                        subText: droneFifthDataText),
                    InfoBox(
                        text: droneSixthDataValue,
                        subText: droneSixthDataText),
                  ],
                ),
                SizedBox(height: spaceBetweenWidgets / 4),
                Expanded(
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
                        kmlName: 'Drone')),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
