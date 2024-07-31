import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';

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
      title: infoPageTitle,
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
                    projectTitle,
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
                        projectSubtitle,
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
                  infoPageDescription,
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
