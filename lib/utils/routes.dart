import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/home_page.dart';
import 'package:lg_space_visualizations/pages/splash_screen.dart';

Route<dynamic> makeRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/splash':
      return customRoute(const SplashPage());
    case '/home':
      return customRoute(const HomePage());
    default:
      return customRoute(const HomePage());
  }
}

PageRouteBuilder customRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation1, animation2) => page,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, animation2, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
