import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/costants.dart';
import 'package:lg_space_visualizations/utils/kml/ballon_maker.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/view_model.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/info_box.dart';

/// [RoverPage] is a stateful widget that displays information about the Perseverance Rover.
///
/// It includes a 3D model of the rover, buttons to inspect the rover and see its cameras.
class RoverPage extends StatefulWidget {
  const RoverPage({super.key});

  @override
  _RoverPageState createState() => _RoverPageState();
}

class _RoverPageState extends State<RoverPage> {
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

  /// Display a balloon with information about the Perseverance Rover.
  void displayBalloon() async {
    await lgConnection.setPlanet('mars');
    await lgConnection.sendKMLToSlave(lgConnection.rightScreen,
        BalloonMaker.generatePerseveranceRoverBalloon());
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
                const ViewModel(
                  model: 'assets/models/perseverance_rover.glb',
                  backgroundImage: 'assets/images/model_background.png',
                  alt: 'perseverance rover',
                  cameraOrbit: '-10deg 78deg 5.5m',
                ),
                SizedBox(height: spaceBetweenWidgets - 5),
                Button(
                  color: secondaryColor,
                  center: false,
                  text: 'Inspect Rover',
                  padding: const EdgeInsets.only(left: 15),
                  borderRadius: BorderRadius.circular(borderRadius),
                  icon: CustomIcon(
                      name: 'mechanic', size: 50, color: backgroundColor),
                  onPressed: () {
                    setState(() {
                      Navigator.pushNamed(context, '/web', arguments: {
                        'url': inspectRoverUrl,
                        'title': 'Inspect Perseverance Rover'
                      });
                    });
                  },
                ),
                SizedBox(height: spaceBetweenWidgets / 2),
                Button(
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
                ),
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
                Text(
                  roverIntroText + roverDescriptionText,
                  style: smallText,
                ),
                Text(
                  "Path",
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
                    InfoBox(text: '1025 kg', subText: 'Mass'),
                    InfoBox(text: '10x9x7 m', subText: 'Dimensions'),
                    InfoBox(text: '2 GB', subText: 'Flash Memory'),
                    InfoBox(text: '200 MHz', subText: 'Processor Speed'),
                    InfoBox(text: '4.8 kg', subText: 'Plutonium Dioxide Fuel'),
                    InfoBox(text: '152 m/h', subText: 'Top Speed')
                  ],
                ),
                const Spacer(),
                Button(
                  color: secondaryColor,
                  text: 'See rover cameras',
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  borderRadius: BorderRadius.circular(borderRadius),
                  icon: CustomIcon(
                      name: 'cameras', size: 40, color: backgroundColor),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
