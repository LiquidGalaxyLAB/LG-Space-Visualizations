import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/cameras_images_page.dart';
import 'package:lg_space_visualizations/pages/cameras_page.dart';
import 'package:lg_space_visualizations/pages/drone_page.dart';
import 'package:lg_space_visualizations/pages/home_page.dart';
import 'package:lg_space_visualizations/pages/info_page.dart';
import 'package:lg_space_visualizations/pages/mars_page.dart';
import 'package:lg_space_visualizations/pages/orbit_page.dart';
import 'package:lg_space_visualizations/pages/orbits_page.dart';
import 'package:lg_space_visualizations/pages/rover_page.dart';
import 'package:lg_space_visualizations/pages/services_page.dart';
import 'package:lg_space_visualizations/pages/settings_page.dart';
import 'package:lg_space_visualizations/pages/splash_screen.dart';
import 'package:lg_space_visualizations/pages/web_page.dart';
import 'package:lg_space_visualizations/utils/orbit.dart';
import 'package:lg_space_visualizations/utils/sol_day.dart';

/// Generates a [Route] for the application based on the provided [RouteSettings].
///
/// This function takes [settings] as a parameter, which contains the name of
/// the route to be generated. It returns a [Route] corresponding to the route
/// name. If the route name is not recognized, it defaults to the home page.
Route<dynamic>? makeRoute(RouteSettings settings) {
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
    case '/services':
      // Route for the services page.
      builder = (BuildContext context) => const ServicesPage();
      break;
    case '/info':
      // Route for the info screen.
      builder = (BuildContext context) => const InfoPage();
      break;
    case '/mars':
      // Route for the mars screen.
      builder = (BuildContext context) => const MarsPage();
      break;
    case '/rover':
      // Route for the rover screen.
      builder = (BuildContext context) => const RoverPage();
      break;
    case '/drone':
      // Route for the drone screen.
      builder = (BuildContext context) => const DronePage();
      break;
    case '/cameras':
      // Route for the cameras screen.
      builder = (BuildContext context) => const CamerasPage();
      break;
    case '/orbits':
      // Route for the orbits screen.
      builder = (BuildContext context) => const OrbitsPage();
      break;
    case '/orbit':
      // Route for the orbit screen.

      // Retrieve the arguments passed to the route.
      final arguments = settings.arguments;

      if (arguments is Orbit) {
        // If valid arguments are provided, set the builder to route to OrbitPage.
        builder = (BuildContext context) => OrbitPage(orbit: arguments);
      } else {
        // If arguments are invalid, set the builder to route to HomePage (default).
        builder = (BuildContext context) => const HomePage();
      }
      break;
    case '/cameras_images':
      // Route for the cameras images screen.

      // Retrieve the arguments passed to the route.
      final arguments = settings.arguments;

      // Check if the arguments are a SolDay and a list of strings.
      if (arguments is List<Object> &&
          arguments[0] is SolDay &&
          arguments[1] is List<String>) {
        builder = (BuildContext context) => CamerasImagesPage(
            day: arguments[0] as SolDay,
            camerasSelected: arguments[1] as List<String>);
      } else {
        // If arguments are invalid, set the builder to route to HomePage (default).
        builder = (BuildContext context) => const HomePage();
      }
      break;
    case '/web':
      // Route for the web screen.

      // Retrieve the arguments passed to the route.
      final arguments = settings.arguments;

      // Check if the arguments are a map containing 'url' and 'title' keys.
      if (arguments is Map<String, String> &&
          arguments.containsKey('url') &&
          arguments.containsKey('title')) {
        // If valid arguments are provided, set the builder to route to WebPage.
        builder = (BuildContext context) =>
            WebPage(url: arguments['url']!, title: arguments['title']!);
      } else {
        // If arguments are invalid, set the builder to route to HomePage (default).
        builder = (BuildContext context) => const HomePage();
      }
      break;
    default:
      return null;
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
