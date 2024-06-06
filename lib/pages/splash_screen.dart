import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/logo.dart';

/// A widget that represents the splash screen of the app.
///
/// It displays the logos and a loading indicator at the bottom.
/// When initialized, it waits for 5 seconds before navigating to the home page.s
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Timer to navigate to the home page after 5 seconds.
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Logo(),
            Expanded(
              child:
                  Image.asset('assets/images/logos.png', fit: BoxFit.contain),
            ),
            SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                color: backgroundColor,
                backgroundColor: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
