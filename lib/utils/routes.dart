import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/home_page.dart';

Route<dynamic> makeRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return customRoute(const HomePage());
    default:
      throw 'Route is not defined';
  }
}

PageRouteBuilder customRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation1, animation2) => page,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, animation2, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
