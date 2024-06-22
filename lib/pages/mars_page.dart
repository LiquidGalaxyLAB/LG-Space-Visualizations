import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
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
  Widget build(BuildContext context) {
    return TemplatePage(title: "Mars 2020", children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: backgroundColor,
            image: const DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage("assets/images/rover.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.only(
            top: spaceBetweenWidgets / 2,
            left: 2 * spaceBetweenWidgets,
            right: 2 * spaceBetweenWidgets,
            bottom: spaceBetweenWidgets / 2,
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
                    'The Mars 2020 Perseverance Rover searches for signs of ancient microbial life, to advance NASA\'s quest to explore the past habitability of Mars. The rover is collecting core samples of Martian rock and soil, for potential pickup by a future mission that would bring them to Earth for detailed study.  Perseverance also tests technologies needed for the future human and robotic exploration of Mars.',
                    style: smallText,
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoBox(text: '30 July 2020', subText: 'Launch'),
                      InfoBox(text: '18 Feb 2021', subText: 'Landing'),
                      InfoBox(text: 'Jezero Crater', subText: 'Location'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'NASA chose Jezero Crater as the landing site for the Perseverance rover. Scientists believe the area was once flooded with water and was home to an ancient river delta. The process of landing site selection involved a combination of mission team members and scientists from around the world, who carefully examined more than 60 candidate locations on the Red Planet. After the exhaustive five-year study of potential sites, each with its own unique characteristics and appeal, Jezero rose to the top.',
                    style: smallText,
                  ),
                  SizedBox(height: spaceBetweenWidgets),
                  Button(
                    color: secondaryColor,
                    text: 'Read more about the mission',
                    padding: const EdgeInsets.only(left: 15),
                    borderRadius: BorderRadius.circular(borderRadius),
                    icon: CustomIcon(
                        name: 'read', size: 50, color: backgroundColor),
                    onPressed: () {},
                  ),
                  SizedBox(height: spaceBetweenWidgets / 2),
                  Button(
                      color: secondaryColor,
                      text: 'Meet Perseverance Rover',
                      padding: const EdgeInsets.only(left: 15),
                      borderRadius: BorderRadius.circular(borderRadius),
                      icon: CustomIcon(
                          name: 'rover', size: 50, color: backgroundColor),
                      onPressed: () {}),
                  SizedBox(height: spaceBetweenWidgets / 2),
                  Button(
                    color: secondaryColor,
                    text: 'Meet Ingenuity Drone',
                    padding: const EdgeInsets.only(left: 15),
                    borderRadius: BorderRadius.circular(borderRadius),
                    icon: CustomIcon(
                        name: 'drone', size: 50, color: backgroundColor),
                    onPressed: () {},
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
