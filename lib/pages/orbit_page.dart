import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/kml/ballon_maker.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/orbit.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/map.dart';

/// A page that displays detailed information and visualizations for a specific [Orbit].
class OrbitPage extends StatefulWidget {
  /// The [Orbit] instance to display.
  final Orbit orbit;

  const OrbitPage({super.key, required this.orbit});

  @override
  _OrbitPageState createState() => _OrbitPageState();
}

class _OrbitPageState extends State<OrbitPage> {
  /// Controller for the Google Map.
  GoogleMapController? mapController;

  /// Set of polylines to display the orbit path on the map.
  final Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    loadPolylines();
    showVisualizations();
  }

  @override
  void dispose() {
    // Clear the KML when the page is disposed, keeping the logos
    lgConnection.clearKml(keepLogos: true);
    super.dispose();
  }

  /// Sends the KML file to the Liquid Galaxy for visualization.
  showVisualizations() async {
    // Clear the KML on the LG
    await lgConnection.clearKml(keepLogos: true);

    // Display a balloon with information about the orbit
    await lgConnection.sendKMLToSlave(
        lgConnection.rightScreen,
        BalloonMaker.generateOrbitBalloon(
            widget.orbit.orbitName, widget.orbit.orbitDescription));

    // Send the KML file of the orbit's path to the LG
    await lgConnection.sendKmlFromAssets(widget.orbit.kmlPath);
  }

  /// Loads the polylines from the KML file to display the orbit path on the map.
  Future<void> loadPolylines() async {
    List<LatLng> path = await parseKmlFromAssets(widget.orbit.kmlPath);
    setState(() {
      polylines.add(Polyline(
        polylineId: const PolylineId('orbit_path'),
        points: path,
        color: Colors.white,
        width: 3,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: widget.orbit.orbitName,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: spaceBetweenWidgets,
                right: spaceBetweenWidgets,
                top: spaceBetweenWidgets / 2,
                bottom: spaceBetweenWidgets,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About ${widget.orbit.orbitName}',
                    style: middleTitle,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: spaceBetweenWidgets / 2),

                  Text(
                    widget.orbit.orbitDescription,
                    style: smallText,
                  ),
                  SizedBox(height: spaceBetweenWidgets / 2),

                  // Conditionally displays information about the satellite if available
                  if (widget.orbit.satelliteDescription != null) ...[
                    Text(
                      'About ${widget.orbit.satelliteName} satellite',
                      style: middleTitle,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: spaceBetweenWidgets / 2),
                    Text(
                      widget.orbit.satelliteDescription!,
                      style: smallText,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: spaceBetweenWidgets),
        Expanded(
          flex: 7,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: spaceBetweenWidgets / 2,
                right: spaceBetweenWidgets / 2,
                top: spaceBetweenWidgets / 2,
                bottom: spaceBetweenWidgets / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Map(
                      latitude: widget.orbit.centerLatitude,
                      longitude: widget.orbit.centerLongitude,
                      zoom: defaultEarthMapZoom,
                      tilt: defaultEarthMapTilt,
                      bearing: defaultEarthMapBearing,
                      mapType: MapType.satellite,
                      boost: defaultEarthMapBoost,
                      polylines: polylines,
                      orbitTilt: defaultEarthOrbitTilt,
                      orbitRange: defaultEarthOrbitRange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Parses a KML file from the asset bundle ([assetPath] and extracts the coordinates to create a path.
///
/// Returns a list of [LatLng] points representing the path.
Future<List<LatLng>> parseKmlFromAssets(String assetPath) async {
  final xmlString = await rootBundle.loadString(assetPath);
  List<LatLng> path = [];
  RegExp exp = RegExp(r'<coordinates>(.*?)<\/coordinates>');
  var matches = exp.allMatches(xmlString);

  for (var match in matches) {
    String coordinateString = match.group(1) ?? "";
    List<String> coordinatePairs = coordinateString.split(' ');

    for (String pair in coordinatePairs) {
      List<String> coords = pair.split(',');
      if (coords.length >= 2) {
        double? longitude = double.tryParse(coords[0].trim());
        double? latitude = double.tryParse(coords[1].trim());
        if (latitude != null && longitude != null) {
          path.add(LatLng(latitude, longitude));
        }
      }
    }
  }
  return path;
}
