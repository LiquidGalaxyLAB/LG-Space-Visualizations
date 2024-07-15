import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/info_box.dart';

/// [MarsPage] is a widget that represents the overview page for the Mars 2020 mission.
class MarsPage extends StatefulWidget {
  const MarsPage({super.key});

  @override
  _MarsPageState createState() => _MarsPageState();
}

class _MarsPageState extends State<MarsPage> {
  @override
  void initState() {
    super.initState();
    lgConnection.setPlanet('mars');
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(title: 'Mars 2020', children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: backgroundColor,
            image: const DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage('assets/images/rover.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.only(
            top: spaceBetweenWidgets / 4,
            left: spaceBetweenWidgets,
            right: spaceBetweenWidgets,
            bottom: spaceBetweenWidgets / 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mission overview",
                    style: middleTitle,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    missionOverviewIntroText,
                    style: smallText,
                  ),
                  SizedBox(height: spaceBetweenWidgets / 2),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoBox(text: '30 July 2020', subText: 'Launch'),
                      InfoBox(text: '18 Feb 2021', subText: 'Landing'),
                      InfoBox(text: 'Jezero Crater', subText: 'Location'),
                    ],
                  ),
                  SizedBox(height: spaceBetweenWidgets / 3),
                  Text(
                    missionOverviewDescriptionText,
                    style: smallText,
                  ),
                  SizedBox(height: spaceBetweenWidgets / 1.5),
                  Button(
                    color: secondaryColor,
                    center: false,
                    text: 'Read more about the mission',
                    padding: const EdgeInsets.only(left: 15),
                    borderRadius: BorderRadius.circular(borderRadius),
                    icon: CustomIcon(
                        name: 'read', size: 50, color: backgroundColor),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/web', arguments: {
                          'url': missionOverviewUrl,
                          'title': 'Mars 2020'
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
                  SizedBox(height: spaceBetweenWidgets / 2),
                  Button(
                    color: secondaryColor,
                    center: false,
                    text: 'Meet Ingenuity Drone',
                    padding: const EdgeInsets.only(left: 15),
                    borderRadius: BorderRadius.circular(borderRadius),
                    icon: CustomIcon(
                        name: 'drone', size: 50, color: backgroundColor),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/drone');
                      });
                    },
                  ),
                  SizedBox(height: spaceBetweenWidgets / 2),
                  Button(
                    color: secondaryColor,
                    center: false,
                    text: 'See Landing Simulation',
                    padding: const EdgeInsets.only(left: 15),
                    borderRadius: BorderRadius.circular(borderRadius),
                    icon: CustomIcon(
                        name: 'landing', size: 50, color: backgroundColor),
                    onPressed: () {
                      setState(() {
                        setState(() {
                          Navigator.pushNamed(context, '/web', arguments: {
                            'url': landingUrl,
                            'title': 'Mars Landing Simulation'
                          });
                        });
                      });
                    },
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    ]);
  }
}
