import 'package:lg_space_visualizations/utils/costants.dart';

/// A class representing a photo taken by the Mars rover. It requires an image source URL [imgSrc] and the [camera] that took the photo.
class RoverPhoto {
  /// URL of the image source
  final String imgSrc;

  /// Short name of the camera that took the photo
  final String camera;

  RoverPhoto({required this.imgSrc, required this.camera});

  /// Returns the full name of the camera based on the camera short name
  get fullCameraName => cameras[camera] ?? camera;

  /// Overriding the equality operator to compare RoverPhoto objects. This is used to check if a photo is already present in the list.
  @override
  bool operator ==(Object other) {
    // Equality check based on the image source URL
    return other is RoverPhoto && imgSrc == other.imgSrc;
  }

  /// Overriding the hash code getter to generate a hash code based on the image source URL. This is used to check if a photo is already present in the list.
  @override
  int get hashCode => imgSrc.hashCode;
}
