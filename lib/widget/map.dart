import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lg_space_visualizations/utils/constants.dart';
import 'package:lg_space_visualizations/utils/lg_connection.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/utils/text_constants.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';

/// The [Map] widget displays a Google Map with a specific [latitude], [longitude], [tilt], [bearing] and [zoom] level. The zoom level can be adjusted using the [boost] parameter.
///
/// The map can be constrained to a specific [bounds] if provided, it can also display a set of [polylines] on the map.
/// It also loads a KML layer on the map based on the [kmlName] provided. The [mapType] can be set to display a specific type of map.
/// A [minMaxZoomPreference] can be set to limit the zoom levels of the map. If a [canOrbit] flag is set to true, the map can be orbited with a specific [orbitTilt] and [orbitRange].
class Map extends StatefulWidget {
  // Latitude for the center of the map
  double latitude;

  // Longitude for the center of the map
  double longitude;

  // Initial zoom level for the map
  double zoom;

  // Fixed tilt angle of the map view
  final double tilt;

  // Fixed bearing angle of the map view
  double bearing;

  // Type of KML to load, in this case Drone or Rover
  final String? kmlName;

  // Type of map to display, default is none
  final MapType mapType;

  // Set of polylines to display on the map
  final Set<Polyline> polylines;

  // Min and max zoom levels for the map const MinMaxZoomPreference(11, 14);
  final MinMaxZoomPreference minMaxZoomPreference;

  // Optional bounds to constrain the camera's target
  final LatLngBounds? bounds;

  // Optional boost value to increase the zoom level
  final int boost;

  // Orbit tilt angle
  final double orbitTilt;

  // Orbit range
  final double orbitRange;

  // Flag to check if the map can orbit
  final bool canOrbit;

  Map(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.zoom,
      required this.tilt,
      required this.bearing,
      required this.orbitTilt,
      required this.orbitRange,
      this.mapType = MapType.none,
      this.polylines = const {},
      this.kmlName,
      this.bounds,
      this.boost = 0,
      this.canOrbit = true,
      this.minMaxZoomPreference = MinMaxZoomPreference.unbounded});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> with SingleTickerProviderStateMixin {
  late GoogleMapController mapController; // Controller for Google Map
  late AnimationController
      rotationOrbitController; // Controller for the Icon rotation animation
  bool isOrbiting = false; // Flag to check if the map is currently orbiting

  @override
  void initState() {
    super.initState();
    // Initialize the rotationOrbitController
    rotationOrbitController = AnimationController(
      duration: const Duration(seconds: 50),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // Dispose the rotationOrbitController
    rotationOrbitController.dispose();

    // Stop the orbiting if it is currently active
    lgConnection.stopOrbit();

    super.dispose();
  }

  /// Stops the orbiting of the Liquid Galaxy.
  Future<void> stopOrbit() async {
    await lgConnection.stopOrbit();
    rotationOrbitController.stop();
    _onCameraIdle();
  }

  /// Starts the orbiting of the Liquid Galaxy.
  Future<void> startOrbit() async {
    await lgConnection.buildOrbit(mapMarsCenterLat, mapMarsCenterLong,
        widget.orbitRange, widget.orbitTilt, defaultMarsMapBearing);
    rotationOrbitController.repeat();
  }

  /// Converts a zoom level to an altitude for Google Earth visualization.
  double zoomToGoogleEarthAltitude(int zoom) {
    zoom = zoom + widget.boost;

    return (591657550.500000 / pow(2, zoom)) / lgConnection.screenAmount;
  }

  /// Initializes the map controller and loads a KML layer if a KML name is provided.
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Add the KML layer to the map if a KML name is provided
    if (widget.kmlName != null) {
      addKml(mapController, 'map#add${widget.kmlName}KML');
    }
  }

  /// Handles camera movement events.
  /// This method ensures the camera's target stays within predefined bounds.
  Future<void> _onCameraMove(CameraPosition position) async {
    print('Camera moved to: ${position.target}');
    if (widget.bounds == null) {
      // Update the widget's state to reflect the new or adjusted camera position
      widget.longitude = position.target.longitude;
      widget.latitude = position.target.latitude;
      widget.zoom = position.zoom;
      widget.bearing = position.bearing;
    } else {
      // Extract the target coordinates from the current camera position
      LatLng target = position.target;

      // Retrieve the currently visible region of the map to determine its boundaries
      LatLngBounds visibleRegion = await mapController.getVisibleRegion();

      // Initialize variables to hold the potentially adjusted coordinates
      double constrainedLat = target.latitude;
      double constrainedLng = target.longitude;

      // Constrain the latitude:
      // If the camera's southern boundary is below the allowed minimum, adjust latitude upwards
      if (visibleRegion.southwest.latitude <
          widget.bounds!.southwest.latitude) {
        constrainedLat = widget.bounds!.southwest.latitude +
            (visibleRegion.northeast.latitude - target.latitude);
      }
      // If the camera's northern boundary exceeds the allowed maximum, adjust latitude downwards
      else if (visibleRegion.northeast.latitude >
          widget.bounds!.northeast.latitude) {
        constrainedLat = widget.bounds!.northeast.latitude -
            (target.latitude - visibleRegion.southwest.latitude);
      }

      // Constrain the longitude:
      // If the camera's western boundary is left of the allowed minimum, adjust longitude to the right
      if (visibleRegion.southwest.longitude <
          widget.bounds!.southwest.longitude) {
        constrainedLng = widget.bounds!.southwest.longitude +
            (visibleRegion.northeast.longitude - target.longitude);
      }
      // If the camera's eastern boundary exceeds the allowed maximum, adjust longitude to the left
      else if (visibleRegion.northeast.longitude >
          widget.bounds!.northeast.longitude) {
        constrainedLng = widget.bounds!.northeast.longitude -
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
      widget.bearing = position.bearing;
    }
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
    return Stack(children: [
      Positioned.fill(
          child: Container(
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
                  mapType: widget.mapType,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  minMaxZoomPreference: widget.minMaxZoomPreference,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  polylines: widget.polylines,
                ),
              ))),
      if (widget.canOrbit)
        Positioned(
            bottom: 20,
            right: 20,
            child: Tooltip(
              message: toolTipMapOrbitText,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 25.0)
                    .animate(rotationOrbitController),
                child: Builder(builder: (context) {
                  return Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(
                          color: secondaryColor,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Button(
                          padding: const EdgeInsets.all(8),
                          icon: CustomIcon(
                              name: 'orbit', size: 40, color: secondaryColor),
                          onPressed: () async {
                            // Start or stop orbiting based on the current state
                            if (isOrbiting) {
                              await stopOrbit();
                            } else {
                              await startOrbit();
                            }

                            // Update the state to reflect the new orbiting state
                            isOrbiting = !isOrbiting;
                          }));
                }),
              ),
            ))
    ]);
  }
}
