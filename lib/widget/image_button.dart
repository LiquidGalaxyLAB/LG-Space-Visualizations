import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// A widget that displays an image button with text.
///
/// The [ImageButton] widget allows you to display an image with text.
/// The button can be customized with [image], [width], [height], [onPressed], and [text] required parameters .
class ImageButton extends StatelessWidget {
  /// The image to be displayed inside the button.
  final ImageProvider image;

  /// The width of the button.
  final double width;

  /// The height of the button.
  final double height;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// The text to be displayed inside the button.
  final String text;

  const ImageButton({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          image: DecorationImage(
            image: image,
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(spaceBetweenWidgets),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              text,
              style: bigTitle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
