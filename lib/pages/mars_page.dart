import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
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
    return TemplatePage(title: marsPageTitle, children: [
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
                    marsPageDescriptionTitle,
                    style: middleTitle,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    marsPageIntroText,
                    style: smallText,
                  ),
                  SizedBox(height: spaceBetweenWidgets / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoBox(
                          text: marsPageFirstDataValue,
                          subText: marsPageFirstDataText),
                      InfoBox(
                          text: marsPageSecondDataValue,
                          subText: marsPageSecondDataText),
                      InfoBox(
                          text: marsPageThirdDataValue,
                          subText: marsPageThirdDataText),
                    ],
                  ),
                  SizedBox(height: spaceBetweenWidgets / 3),
                  Text(
                    marsPageDescriptionText,
                    style: smallText,
                  ),
                  SizedBox(height: spaceBetweenWidgets / 1.5),
                  Button(
                    color: secondaryColor,
                    center: false,
                    text: marsPageLearnMoreText,
                    padding: const EdgeInsets.only(left: 15),
                    borderRadius: BorderRadius.circular(borderRadius),
                    icon: CustomIcon(
                        name: 'read', size: 50, color: backgroundColor),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/web', arguments: {
                          'url': missionOverviewUrl,
                          'title': marsPageTitle
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
                  SizedBox(height: spaceBetweenWidgets / 2),
                  Button(
                    color: secondaryColor,
                    center: false,
                    text: meetTheDroneText,
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
                    text: landingButtonText,
                    padding: const EdgeInsets.only(left: 15),
                    borderRadius: BorderRadius.circular(borderRadius),
                    icon: CustomIcon(
                        name: landingTitle, size: 50, color: backgroundColor),
                    onPressed: () {
                      setState(() {
                        setState(() {
                          Navigator.pushNamed(context, '/web', arguments: {
                            'url': landingUrl,
                            'title': landingTitle
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
