import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/kml/ballon_maker.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/orbit.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

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

  /// The showcase keys
  final GlobalKey _oneShowCase = GlobalKey();
  final GlobalKey _twoShowCase = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadPolylines();
    showVisualizations();

    // Show the showcase tutorial if it's the first time the user opens the page
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('showcaseOrbitPage') ?? true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowCaseWidget.of(context).startShowCase([
            _oneShowCase,
            _twoShowCase,
          ]);
          prefs.setBool('showcaseOrbitPage', false);
        });
      }
    });
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
          child: Showcase(
            key: _oneShowCase,
            targetBorderRadius: BorderRadius.circular(borderRadius),
            title: oneShowcaseOrbitPageTitle,
            description:
                '$oneShowcaseOrbitPageDescription1 ${widget.orbit.orbitName} $oneShowcaseOrbitPageDescription2 ${widget.orbit.satelliteName ?? oneShowcaseOrbitPageDescription3} $oneShowcaseOrbitPageDescription4',
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
                        '$orbitDescriptionTitle ${widget.orbit.orbitName}',
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
                          '$orbitDescriptionTitle ${widget.orbit.satelliteName} $orbitSatellite',
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
                  )),
            ),
          ),
        ),
        SizedBox(width: spaceBetweenWidgets),
        Expanded(
          flex: 7,
          child: Showcase(
              key: _twoShowCase,
              targetBorderRadius: BorderRadius.circular(borderRadius),
              title: twoShowcaseOrbitPageTitle,
              description: twoShowcaseOrbitPageDescription,
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
                          canOrbit: false,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }
}

/// Parses a KML file from the asset bundle ([assetPath] and extracts the coordinates to create a path.
///
/// Returns a list of [LatLng] points representing the path.
Future<List<LatLng>> parseKmlFromAssets(String assetPath) async {
  // Load the KML file as a string from the asset path provided
  final xmlString = await rootBundle.loadString(assetPath);

  // Initialize an empty list to store the parsed coordinates as LatLng objects
  List<LatLng> path = [];

  // Regular expression to find all <coordinates> tags and capture the content between them
  RegExp exp = RegExp(r'<coordinates[^>]*>(.*?)<\/coordinates>', dotAll: true);

  // Find all matches of the regular expression in the XML string
  var matches = exp.allMatches(xmlString);

  // Loop through all matches (each match represents a set of coordinates)
  for (var match in matches) {
    // Extract the coordinate string from the match (group 1 captures the contents of the <coordinates> tag)
    String coordinateString = match.group(1) ?? "";

    // Split the coordinate string into individual coordinate pairs (separated by whitespace)
    List<String> coordinatePairs = coordinateString.split(RegExp(r'\s+'));

    // Loop through each coordinate pair
    for (String pair in coordinatePairs) {
      // Split the coordinate pair into individual components (longitude, latitude, and possibly altitude)
      List<String> coords = pair.split(',');

      // Check if the pair contains at least a longitude and latitude
      if (coords.length >= 2) {
        // Try to parse the longitude and latitude as double values
        double? longitude = double.tryParse(coords[0].trim());
        double? latitude = double.tryParse(coords[1].trim());

        // If both latitude and longitude are valid numbers, add them as a LatLng object to the path list
        if (latitude != null && longitude != null) {
          path.add(LatLng(latitude, longitude));
        }
      }
    }
  }

  // Return the list of parsed LatLng objects
  return path;
}
