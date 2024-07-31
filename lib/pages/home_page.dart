import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/image_button.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/logo.dart';

/// The home page of the application, displayed using the [TemplatePage] widget.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: homePageTitle,
      showTopBar: false,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(height: spaceBetweenWidgets),
              const Logo(),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageButton(
                      width: 425,
                      height: 220,
                      image: const AssetImage('assets/images/rover.png'),
                      text: marsSectionTitle,
                      onPressed: () {
                        setState(() {
                          Navigator.pushNamed(context, '/mars');
                        });
                      },
                    ),
                    ImageButton(
                      width: 425,
                      height: 220,
                      image: const AssetImage('assets/images/earth.png'),
                      text: earthSectionTitle,
                      onPressed: () {
                        setState(() {
                          Navigator.pushNamed(
                            context,
                            '/orbits',
                          );
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
