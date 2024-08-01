/// This class is used to generate the KML code from the given parameters.
class KMLMakers {
  /// Generates KML code for a screen overlay image.
  ///
  /// [imageUrl] is the URL of the image to be overlaid.
  ///
  /// Returns a string containing the KML code for the screen overlay image.
  static String screenOverlayImage(String imageUrl) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document id ="logo">
         <name>Space Visualizations</name>
             <Folder>
                  <name>Splash Screen</name>
                  <ScreenOverlay>
                      <name>Logo</name>
                      <Icon><href>$imageUrl</href></Icon>                    
                      <overlayXY x="0.5" y="1" xunits="fraction" yunits="fraction"/>
                      <screenXY x="0.5" y="0.98" xunits="fraction" yunits="fraction"/>
                      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
                      <size x="0.5" y="0" xunits="fraction" yunits="fraction"/>
                  </ScreenOverlay>
             </Folder>
    </Document>
</kml>''';

  /// Generates KML code for a balloon overlay.
  ///
  /// The balloon overlay includes the HTML content provided.
  ///
  /// [htmlContent] is a string that contains the HTML content to be displayed in the balloon overlay.
  ///
  /// Returns a string containing the KML code for the balloon overlay.
  static String screenOverlayBalloon(String htmlContent) {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document id="balloon">
   <name>Balloon</name>
  <open>1</open>
  <Style id="purple_paddle">
    <BalloonStyle>
          <text><![CDATA[
          $htmlContent
      ]]></text>
      <bgColor>ff1e1e1e</bgColor>
    </BalloonStyle>
  </Style>
    <styleUrl>#purple_paddle</styleUrl>
    <gx:balloonVisibility>1</gx:balloonVisibility>
</Document>
</kml>
''';
  }

  /// Generates a blank KML document.
  ///
  /// [id] is the identifier for the document.
  ///
  /// Returns a string containing the KML code for a blank document.
  static String generateBlank(String id) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="$id">
  </Document>
</kml>''';

  /// Generates KML code for a LookAt element with linear motion.
  ///
  /// [latitude] is the latitude of the location.
  /// [longitude] is the longitude of the location.
  /// [zoom] is the zoom level.
  /// [tilt] is the tilt angle.
  /// [bearing] is the bearing angle.
  ///
  /// Returns a string containing the KML code for the LookAt element.
  static String lookAtLinear(double latitude, double longitude, double zoom, double tilt, double bearing) =>
      '<LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

  /// Generates KML code for an orbiting LookAt element with linear motion.
  ///
  /// [latitude] is the latitude of the location.
  /// [longitude] is the longitude of the location.
  /// [zoom] is the zoom level.
  /// [tilt] is the tilt angle.
  /// [bearing] is the bearing angle.
  ///
  /// Returns a string containing the KML code for the orbiting LookAt element.
  static String orbitLookAtLinear(double latitude, double longitude, double zoom, double tilt, double bearing) =>
      '<gx:duration>60</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

  /// Generates KML code for an instant LookAt element with linear motion.
  ///
  /// [latitude] is the latitude of the location.
  /// [longitude] is the longitude of the location.
  /// [zoom] is the zoom level.
  /// [tilt] is the tilt angle.
  /// [bearing] is the bearing angle.
  ///
  /// Returns a string containing the KML code for the instant LookAt element.
  static String lookAtLinearInstant(double latitude, double longitude, double zoom, double tilt, double bearing) =>
      '<gx:duration>0.5</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';
}
