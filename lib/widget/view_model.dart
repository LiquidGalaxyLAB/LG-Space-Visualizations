import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// [ViewModel] is a widget that displays a 3D model
/// using the [ModelViewer] widget from the model_viewer_plus package.
/// It also includes a background image behind the 3D model.
///
/// [model] is the path to the 3D model file, [backgroundImage] is the path to the background image,
/// [alt] is the alternative text description of the 3D model, and [cameraOrbit] is the initial camera orbit settings.
class ViewModel extends StatelessWidget {
  final String model;
  final String backgroundImage;
  final String alt;
  final String cameraOrbit;

  const ViewModel({
    super.key,
    required this.model,
    required this.backgroundImage,
    required this.alt,
    required this.cameraOrbit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: secondaryColor,
            width: 10,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
            ModelViewer(
              // Sets the background color to transparent.
              backgroundColor: Colors.transparent,
              // The source of the 3D model.
              src: model,
              // Alternative text for the 3D model.
              alt: alt,
              // Enables augmented reality mode.
              ar: true,
              // Initial camera orbit settings.
              cameraOrbit: cameraOrbit,
              // Rotation speed of the model.
              rotationPerSecond: '15deg',
              // Enables auto-rotation of the model.
              autoRotate: true,
              // Zoom functionality.
              disableZoom: false,
              // Disables debug logging.
              debugLogging: false,
              // Disables tap interaction.
              disableTap: true,
            ),
          ],
        ),
      ),
    );
  }
}
