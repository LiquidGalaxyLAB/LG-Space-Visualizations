class Orbit {
  static tag(double latitude, double longitude, double range, double tilt,
      double bearing) {
    double heading = bearing;
    int orbit = 0;
    String content = '';

    while (orbit <= 36) {
      if (heading >= 360) heading -= 360;
      content += '''
            <gx:FlyTo>
              <gx:duration>1.2</gx:duration>
              <gx:flyToMode>smooth</gx:flyToMode>
              <LookAt>
                  <longitude>$longitude</longitude>
                  <latitude>$latitude</latitude>
                  <heading>$heading</heading>
                  <tilt>$tilt</tilt>
                  <range>$range</range>
                  <altitude>0</altitude> 
                  <gx:altitudeMode>relativeToGround</gx:altitudeMode>
              </LookAt>
            </gx:FlyTo>
          ''';
      heading += 10;
      orbit += 1;
    }

    return content;
  }

  static buildOrbit(String content) {
    String kmlOrbit = '''
<?xml version="1.0" encoding="UTF-8"?>
      <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
        <gx:Tour>
          <name>Orbit</name>
          <gx:Playlist> 
            $content
          </gx:Playlist>
        </gx:Tour>
      </kml>
    ''';

    return kmlOrbit;
  }
}
