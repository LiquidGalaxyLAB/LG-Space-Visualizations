import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lg_space_visualizations/utils/routes.dart';

void main() {
  // Ensures that an instance of the widgets library is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Set landscape preferred orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set app in fullscreen mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const Launcher());
}

class Launcher extends StatelessWidget {
  const Launcher({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: MaterialApp(
          title: 'SpaceVisualizations',
          theme: ThemeData(fontFamily: 'Forgotten Futurist'),
          onGenerateRoute: makeRoute,
          initialRoute: '/splash',
        ));
  }
}