import 'package:flutter/material.dart';

/// A widget that displays a custom icon from the asset folder.
///
/// The [CustomIcon] widget allows you to display a custom icon by providing the
/// [name] of the icon file with its [size], and [color].
class CustomIcon extends StatelessWidget {
  /// The name of the icon file (without extension) to be displayed.
  final String name;

  /// The size of the icon.
  final double size;

  /// The color to apply to the icon.
  final Color color;

  const CustomIcon({
    super.key,
    required this.name,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/$name.png',
      height: size,
      color: color,
    );
  }
}
