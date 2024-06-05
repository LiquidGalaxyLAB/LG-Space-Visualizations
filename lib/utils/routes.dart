import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/home_page.dart';
import 'package:lg_space_visualizations/pages/splash_screen.dart';

Route<dynamic> makeRoute(RouteSettings settings) {
  WidgetBuilder builder;
  switch (settings.name) {
    case '/home':
      builder = (BuildContext context) => const HomePage();
      break;
    case '/splash':
      builder = (BuildContext context) => const SplashPage();
      break;
    default:
      builder = (BuildContext context) => const HomePage();
  }
  return AnimationPageRoute(builder: builder, settings: settings);
}

class AnimationPageRoute<T> extends MaterialPageRoute<T> {
  AnimationPageRoute({required super.builder, super.settings});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
