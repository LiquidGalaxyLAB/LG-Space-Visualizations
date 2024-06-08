import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/home_page.dart';
import 'package:lg_space_visualizations/pages/splash_screen.dart';
import 'package:lg_space_visualizations/pages/settings_page.dart';

/// Generates a [Route] for the application based on the provided [RouteSettings].
///
/// This function takes [settings] as a parameter, which contains the name of
/// the route to be generated. It returns a [Route] corresponding to the route
/// name. If the route name is not recognized, it defaults to the home page.
Route<dynamic> makeRoute(RouteSettings settings) {
  WidgetBuilder builder;
  switch (settings.name) {
    case '/home':
      // Route for the home page.
      builder = (BuildContext context) => const HomePage();
      break;
    case '/splash':
      // Route for the splash screen.
      builder = (BuildContext context) => const SplashPage();
      break;
    case '/settings':
      // Route for the settings page.
      builder = (BuildContext context) => const SettingsPage();
      break;
    default:
      // Default route if no match is found, redirects to the home page.
      builder = (BuildContext context) => const HomePage();
  }
  // Return a custom route with a very short transition animation.
  return AnimationPageRoute(builder: builder, settings: settings);
}

/// A custom [MaterialPageRoute] that disables transition animations but keeps a transition duration of 10 ms.
class AnimationPageRoute<T> extends MaterialPageRoute<T> {
  AnimationPageRoute({required super.builder, super.settings});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 10);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Return the child widget without any transition animations.
    return child;
  }
}
