import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lg_space_visualizations/utils/routes.dart';

void main() {
  // Ensures that an instance of the widgets library is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Set the preferred orientation to landscape.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set the app in fullscreen mode, hiding the system UI overlays.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const Launcher());
}

/// The Launcher widget serves as the entry point for the app.
///
/// It sets up the background image, the theme, and the initial route for the app.
class Launcher extends StatelessWidget {
  const Launcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set a background image for the entire app.
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: MaterialApp(
        title: 'SpaceVisualizations',
        // Set the app theme with a custom font.
        theme: ThemeData(fontFamily: 'Forgotten Futurist'),
        // Define the route generator function.
        onGenerateRoute: makeRoute,
        // Set the initial route to the splash screen.
        initialRoute: '/splash',
      ),
    );
  }
}
