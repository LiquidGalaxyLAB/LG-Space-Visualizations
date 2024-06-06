import 'package:flutter/material.dart';

/// A widget that displays a custom icon from the asset folder.
///
/// The [CustomIcon] widget allows you to display a custom icon by providing the
/// [name] of the icon file with its [width], [height], and [color].
class CustomIcon extends StatelessWidget {
  /// The name of the icon file (without extension) to be displayed.
  final String name;

  /// The width of the icon.
  final double width;

  /// The height of the icon.
  final double height;

  /// The color to apply to the icon.
  final Color color;

  const CustomIcon({
    Key? key,
    required this.name,
    required this.width,
    required this.height,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/$name.png',
      width: width,
      height: height,
      color: color,
    );
  }
}
