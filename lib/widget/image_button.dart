import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

class ImageButton extends StatelessWidget {
  final ImageProvider image;
  final double width;
  final double height;
  final VoidCallback onPressed;
  final String text;

  const ImageButton(
      {super.key,
      required this.image,
      required this.width,
      required this.height,
      required this.onPressed,
      required this.text});

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
              child: Text(text, style: bigTitle, textAlign: TextAlign.center),
            ),
          ),
        ));
  }
}
