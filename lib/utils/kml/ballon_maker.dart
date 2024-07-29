import 'package:lg_space_visualizations/utils/constants.dart';

import 'kml_makers.dart';

/// Class responsible for generating KML balloons for various visualizations.
class BalloonMaker {
  /// Generates a KML balloon for the Perseverance Rover.
  ///
  /// The balloon contains an image and a description of the Perseverance Rover.
  ///
  /// Returns a string containing the KML balloon.
  static String generatePerseveranceRoverBalloon() {
    return KMLMakers.screenOverlayBalloon(
        '''<div style="width: 480px; color: white; padding-left: 10px; padding-right: 10px;">
      <center>
        <div>
          <img width="100%" height="auto" src="$roverImageUrl">
        </div>
        <h1 style="color:white; font-size: 28px;">Perseverance Rover</h1>
        <p style="color:white; font-size: 18px;">$roverIntroText</p>
        <br>
        <p style="color:white; font-size: 15px;">Space Visualizations | Liquid Galaxy | GSoC 2024</p>
      </center>
      </div>''');
  }

  /// Generates a KML balloon for the Ingenuity Helicopter.
  ///
  /// The balloon contains an image and a description of the Ingenuity Helicopter.
  ///
  /// Returns a string containing the KML balloon.
  static String generateIngenuityHelicopterBalloon() {
    return KMLMakers.screenOverlayBalloon(
        '''<div style="width: 480px; color: white; padding-left: 10px; padding-right: 10px;">
      <center>
        <div>
          <img width="100%" height="auto" src="$droneImageUrl">
        </div>
        <h1 style="color:white; font-size: 28px;">Ingenuity Drone</h1>
        <p style="color:white; font-size: 18px;">$droneIntroText</p>
        <br>
        <p style="color:white; font-size: 15px;">Space Visualizations | Liquid Galaxy | GSoC 2024</p>
      </center>
      </div>''');
  }

  /// Generates a KML balloon with a custom [description] and [name] of an orbit.
  ///
  /// Returns a string containing the KML balloon.
  static String generateOrbitBalloon(String name, String description) {
    description = description.replaceAll('\n', '<br>').replaceAll('\'', '’');

    return KMLMakers.screenOverlayBalloon(
        '''<div style="width: 480px; color: white; padding-left: 10px; padding-right: 10px;">
      <center>
         <h1 style="color:white; font-size: 28px;">$name Orbit</h1>
        <p style="color:white; font-size: 18px;">$description</p>
        <br>
        <p style="color:white; font-size: 15px;">Space Visualizations | Liquid Galaxy | GSoC 2024</p>
      </center>
      </div>''');
  }
}
