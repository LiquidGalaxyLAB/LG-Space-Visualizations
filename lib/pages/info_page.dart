import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// A [InfoPage] widget that displays information about the Space Visualizations project.
///
/// It includes a description of the project and the logos.
class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: 'Info',
      showTopBar: true,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(spaceBetweenWidgets),
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                  const Spacer(),
                  Image.asset('assets/images/logos_compacted.png',
                      fit: BoxFit.contain),
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
            padding: EdgeInsets.only(
              left: spaceBetweenWidgets,
              right: spaceBetweenWidgets,
              bottom: spaceBetweenWidgets,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Space Visualizations",
                    style: hugeTitle.apply(color: primaryColor),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: primaryColor,
                        height: 10,
                        width: 175,
                        margin: const EdgeInsets.only(right: 25),
                      ),
                      Text(
                        "for Liquid Galaxy",
                        style: bigTitle.apply(color: primaryColor),
                      ),
                      Container(
                        color: primaryColor,
                        height: 10,
                        width: 175,
                        margin: const EdgeInsets.only(left: 25),
                      ),
                    ],
                  ),
                ),
                Text(
                  """This project aims to build an educational application dedicated to visualizing orbits and the Mars 2020 mission, utilizing the Liquid Galaxy platform to provide immersive space exploration experiences. The app enables users to see and understand different orbits, such as GPS, QZSS, Graveyard and more in detail. Additionally, it showcases the Mars 2020 mission by featuring interactive 3D models of the Perseverance Rover and the Ingenuity Drone. Users can follow their paths on Mars, view photos taken by the rover, and discover technical details about the mission.""",
                  style: middleText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
