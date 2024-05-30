import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String name;
  final double width;
  final double height;
  final Color color;

  const CustomIcon({super.key,  required this.name, required this.width, required this.height, required this.color});

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