import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/costants.dart';
import 'package:lg_space_visualizations/utils/kml/ballon_maker.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/info_box.dart';
import 'package:lg_space_visualizations/widget/view_model.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';

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
    displayBalloon();
  }

  @override
  void dispose() {
    /// Clear the KML when the page is disposed keeping the logos.
    lgConnection.clearKml(keepLogos: true);
    super.dispose();
  }

  /// Display a balloon with information about the Ingenuity Drone.
  void displayBalloon() async {
    await lgConnection.sendKMLToSlave(lgConnection.rightScreen,
        BalloonMaker.generateIngenuityHelicopterBalloon());
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(title: "Ingenuity Drone", children: [
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
                  text: 'Learn more about the drone',
                  padding: const EdgeInsets.only(left: 15),
                  borderRadius: BorderRadius.circular(borderRadius),
                  icon: CustomIcon(
                      name: 'read', size: 50, color: backgroundColor),
                  onPressed: () {
                    setState(() {
                      setState(() {
                        Navigator.pushNamed(context, '/web', arguments: {
                          'url': droneUrl,
                          'title': 'Ingenuity Drone'
                        });
                      });
                    });
                  },
                ),
                SizedBox(height: spaceBetweenWidgets / 2),
                Button(
                    color: secondaryColor,
                    center: false,
                    text: 'Meet Perseverance Rover',
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
                top: spaceBetweenWidgets / 2,
                bottom: spaceBetweenWidgets / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "About",
                  style: middleTitle,
                  textAlign: TextAlign.left,
                ),
                Text(droneIntroText, style: smallText),
                SizedBox(height: spaceBetweenWidgets / 2),
                Text(droneDescriptionText, style: smallText),
                Text(
                  "Flights",
                  style: middleTitle,
                  textAlign: TextAlign.left,
                ),
                // TODO: add interactive map
                SizedBox(
                    height: 200, child: Placeholder(color: secondaryColor)),
                SizedBox(height: spaceBetweenWidgets / 4),
                Text(
                  "Specifications",
                  style: middleTitle,
                  textAlign: TextAlign.left,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoBox(text: '1.8 Kg', subText: 'Mass'),
                    InfoBox(text: '300 m', subText: 'Flight Range'),
                    InfoBox(text: '5 m', subText: 'Flight Altitude'),
                    InfoBox(text: '1.2 m', subText: 'Blade Span'),
                    InfoBox(text: '350 W', subText: 'Average Flight Power'),
                    InfoBox(text: '10 m/s', subText: 'Top Speed'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
