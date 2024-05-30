import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

class LedStatus extends StatelessWidget {
  final bool isOn;
  final double size;

  const LedStatus({super.key, required this.isOn, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn ? Colors.green : Colors.red,
        border: Border.all(
          color: secondaryColor,
          width: 2.5,
        ),
      ),
    );
  }
}