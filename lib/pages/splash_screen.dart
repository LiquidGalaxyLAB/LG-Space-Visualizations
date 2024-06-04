import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Timer to navigate to home page after 5 seconds
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
                const Spacer(),
                const Logo(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset('assets/images/logos/liquidGalaxy.png',
                      fit: BoxFit.contain, scale: 3),
                  Image.asset(
                    'assets/images/logos/GSoC.png',
                    fit: BoxFit.contain,
                    scale: 2.5,
                  ),
                  Image.asset(
                    'assets/images/logos/anniversary.png',
                    fit: BoxFit.contain,
                    scale: 3.2,
                  ),
                  const SizedBox(width: 70),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    'assets/images/logos/lgEu.png',
                    fit: BoxFit.contain,
                    scale: 13,
                  ),
                  Image.asset(
                    'assets/images/logos/lgLab.png',
                    fit: BoxFit.contain,
                    scale: 3,
                  ),
                  Image.asset(
                    'assets/images/logos/GDGLleida.png',
                    fit: BoxFit.contain,
                    scale: 1.8,
                  ),
                  Image.asset(
                    'assets/images/logos/flutterLleida.png',
                    fit: BoxFit.contain,
                    scale: 4,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/logos/labTIC.png',
                    fit: BoxFit.contain,
                    scale: 4,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/logos/AgrobioTechLleida.png',
                    fit: BoxFit.contain,
                    scale: 4,
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    'assets/images/logos/uni.png',
                    fit: BoxFit.contain,
                    scale: 1.8,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/logos/PERA.png',
                    fit: BoxFit.contain,
                    scale: 4,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/logos/flutter.png',
                    fit: BoxFit.contain,
                    scale: 13,
                  ),
                  const SizedBox(width: 20),
                  Image.asset(
                    'assets/images/logos/android.png',
                    fit: BoxFit.contain,
                    scale: 25,
                  ),
                ]),
                const SizedBox(height: 2),
                SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(
                        color: backgroundColor, backgroundColor: secondaryColor)),
              ])),
    );
  }
}