
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/bottom_bar.dart';
import 'package:lg_space_visualizations/widget/image_button.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/logo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

/// The home page of the application, displayed using the [TemplatePage] widget.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// The showcase keys
  final GlobalKey oneShowCase = GlobalKey();
  final GlobalKey twoShowCase = GlobalKey();

  @override
  void initState() {
    // Clear the KML when the page is disposed, keeping the logos
    lgConnection.clearKml(keepLogos: true);

    super.initState();

    // Show the showcase tutorial if it's the first time the user opens the page
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('showcaseHomePage') ?? true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowCaseWidget.of(context).startShowCase([
            oneBottomBar!,
            twoBottomBar!,
            threeBottomBar!,
            fourBottomBar!,
            fiveBottomBar!,
            oneShowCase,
            twoShowCase,
          ]);
          prefs.setBool('showcaseHomePage', false);
        });
      }
    });
  }

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
                    Showcase(
                        key: oneShowCase,
                        targetBorderRadius: BorderRadius.circular(borderRadius),
                        title: oneShowcaseHomePageTitle,
                        description: oneShowcaseHomePageDescription,
                        child: ImageButton(
                          width: 425,
                          height: 220,
                          image: const AssetImage('assets/images/rover.png'),
                          text: marsSectionTitle,
                          onPressed: () {
                            setState(() {
                              Navigator.pushNamed(context, '/mars');
                            });
                          },
                        )),
                    Showcase(
                        key: twoShowCase,
                        targetBorderRadius: BorderRadius.circular(borderRadius),
                        title: twoShowcaseHomePageTitle,
                        description: twoShowcaseHomePageDescription,
                        child: ImageButton(
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
                        )),
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
