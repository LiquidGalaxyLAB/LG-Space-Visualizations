import 'kml_makers.dart';
import 'package:lg_space_visualizations/utils/costants.dart';

/// Class responsible for generating KML balloons for various visualizations.
class BalloonMaker {

  /// Generates a KML balloon for the Perseverance Rover.
  ///
  /// The balloon contains an image and a description of the Perseverance Rover.
  ///
  /// Returns a string containing the KML balloon.
  static String generatePerseveranceRoverBalloon() {
    // TODO: change the image and description
    return KMLMakers.screenOverlayBalloon(
        '''<div style="width: 400px; color: white; padding-left: 20px; padding-right: 20px;">
      <center>
        <div>
          <img width="100%" height="auto" src="$droneImageUrl">
        </div>
        <h1 style="color:white;">Perseverance Rover</h1>
        <p style="color:white;">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam risus leo, rutrum nec sollicitudin porta, fermentum ac dolor. Sed sed egestas nibh. Morbi augue justo, malesuada finibus felis ac, molestie pharetra sem. Vivamus interdum mi magna, ut auctor nequeì maximus non. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae.
        </p>
        <br><br>
        <p style="color:white;">Space Visualizations | Liquid Galaxy | GSoC 2024</p>
      </center>
      </div>''');
  }

  /// Generates a KML balloon for the Ingenuity Helicopter.
  ///
  /// The balloon contains an image and a description of the Ingenuity Helicopter.
  ///
  /// Returns a string containing the KML balloon.
  static String generateIngenuityHelicopterBalloon() {
    // TODO: change the image and description
    return KMLMakers.screenOverlayBalloon(
        '''<div style="width: 400px; color: white; padding-left: 20px; padding-right: 20px;">
      <center>
        <div>
          <img width="100%" height="auto" src="$droneImageUrl">
        </div>
        <h1 style="color:white;">Ingenuity Drone</h1>
        <p style="color:white;">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam risus leo, rutrum nec sollicitudin porta, fermentum ac dolor. Sed sed egestas nibh. Morbi augue justo, malesuada finibus felis ac, molestie pharetra sem. Vivamus interdum mi magna, ut auctor nequeì maximus non. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae.
        </p>
        <br><br>
        <p style="color:white;">Space Visualizations | Liquid Galaxy | GSoC 2024</p>
      </center>
      </div>''');
  }

  /// Generates a KML balloon with a custom [description] and [name] of an orbit.
  ///
  /// Returns a string containing the KML balloon.
  static String generateOrbitBalloon(String name, String description) {
    return KMLMakers.screenOverlayBalloon(
        '''<div style="width: 400px; color: white; padding-left: 20px; padding-right: 20px;">
      <center>
         <h1 style="color:white;">$name</h1>
        <p style="color:white;">$description</p>
         <br><br>
        <p style="color:white;">Space Visualizations | Liquid Galaxy | GSoC 2024</p>
      </center>
      </div>''');
  }
}