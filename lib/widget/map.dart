import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// The [Map] widget displays a Google Map with a specific [latitude], [longitude], and [zoom] level.
///
/// It also loads a KML layer on the map based on the [kmlName] provided.
class Map extends StatefulWidget {
  // Latitude for the center of the map
  double latitude;

  // Longitude for the center of the map
  double longitude;

  // Initial zoom level for the map
  double zoom;

  // Fixed tilt angle of the map view
  final double tilt = 0;

  // Fixed bearing angle of the map view
  final double bearing = 0;

  // Type of KML to load, in this case Drone or Rover
  final String kmlName;

  Map(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.zoom,
      required this.kmlName});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> with SingleTickerProviderStateMixin {
  late GoogleMapController mapController; // Controller for Google Map

  // Define the bounds for the Mars Perseverance Rover landing site
  final LatLngBounds bounds = LatLngBounds(
    southwest: const LatLng(17.98275998805969, 76.52780706979584),
    northeast: const LatLng(18.88553559552019, 78.14596461992367),
  );

  /// Converts a zoom level to an altitude for Google Earth visualization.
  double zoomToGoogleEarthAltitude(int zoom) {
    var zoomToRange = {
      11: 43,
      12: 25,
      13: 13,
      14: 8,
      15: 4,
      16: 2,
    };

    return (zoomToRange[zoom] ?? 43) * 1000;
  }

  /// Initializes the map controller and loads a KML layer.
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    addKml(mapController, 'map#add${widget.kmlName}KML');
  }

  /// Handles camera movement events.
  /// This method ensures the camera's target stays within predefined bounds.
  Future<void> _onCameraMove(CameraPosition position) async {
    // Extract the target coordinates from the current camera position
    LatLng target = position.target;

    // Retrieve the currently visible region of the map to determine its boundaries
    LatLngBounds visibleRegion = await mapController.getVisibleRegion();

    // Initialize variables to hold the potentially adjusted coordinates
    double constrainedLat = target.latitude;
    double constrainedLng = target.longitude;

    // Constrain the latitude:
    // If the camera's southern boundary is below the allowed minimum, adjust latitude upwards
    if (visibleRegion.southwest.latitude < bounds.southwest.latitude) {
      constrainedLat = bounds.southwest.latitude +
          (visibleRegion.northeast.latitude - target.latitude);
    }
    // If the camera's northern boundary exceeds the allowed maximum, adjust latitude downwards
    else if (visibleRegion.northeast.latitude > bounds.northeast.latitude) {
      constrainedLat = bounds.northeast.latitude -
          (target.latitude - visibleRegion.southwest.latitude);
    }

    // Constrain the longitude:
    // If the camera's western boundary is left of the allowed minimum, adjust longitude to the right
    if (visibleRegion.southwest.longitude < bounds.southwest.longitude) {
      constrainedLng = bounds.southwest.longitude +
          (visibleRegion.northeast.longitude - target.longitude);
    }
    // If the camera's eastern boundary exceeds the allowed maximum, adjust longitude to the left
    else if (visibleRegion.northeast.longitude > bounds.northeast.longitude) {
      constrainedLng = bounds.northeast.longitude -
          (target.longitude - visibleRegion.southwest.longitude);
    }

    // Create a new target position using the potentially adjusted coordinates
    LatLng constrainedTarget = LatLng(constrainedLat, constrainedLng);

    // If the target has been adjusted, update the map's camera to reflect the changes
    if (constrainedTarget != target) {
      mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: constrainedTarget,
          zoom: position.zoom,
          bearing: position.bearing,
          tilt: position.tilt,
        ),
      ));
    }

    // Update the widget's state to reflect the new or adjusted camera position
    widget.longitude = constrainedTarget.longitude;
    widget.latitude = constrainedTarget.latitude;
    widget.zoom = position.zoom;
  }

  /// Updates the LG map visualization on camera idle.
  void _onCameraIdle() {
    _moveLGMap(widget.latitude, widget.longitude, widget.zoom, widget.tilt,
        widget.bearing);
  }

  /// Sends camera position data to an LG system for visualization.
  void _moveLGMap(double latitude, double longitude, double zoom, double tilt,
      double bearing) async {
    await lgConnection.flyTo(latitude, longitude,
        zoomToGoogleEarthAltitude(zoom.toInt()), tilt, bearing);
  }

  /// Adds a KML layer to the map.
  static Future<void> addKml(
      GoogleMapController mapController, String method) async {
    var mapId = mapController.mapId;
    const MethodChannel channel = MethodChannel('flutter.native/helper');
    final MethodChannel kmlchannel =
        MethodChannel('plugins.flutter.dev/google_maps_android_$mapId');
    try {
      int kmlResourceId = await channel.invokeMethod(method);

      await kmlchannel.invokeMethod(method, <String, dynamic>{
        'resourceId': kmlResourceId,
      });
    } on PlatformException catch (e) {
      throw 'Unable to plot map: ${e.message}';
    } catch (e) {
      throw 'Unable to plot map$e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          border: Border.all(
            color: secondaryColor,
            width: 5,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius - 5),
            child: GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: widget.zoom,
                bearing: widget.bearing,
                tilt: widget.tilt,
              ),
              mapType: MapType.none,
              zoomControlsEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(11, 16),
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
            )));
  }
}
