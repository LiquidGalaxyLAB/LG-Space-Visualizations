import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';

/// A Widget that displays a popup with a [child] widget
class PopUp extends StatelessWidget {
  // Child widget to be displayed inside the popup
  final Widget child;

  const PopUp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 60,
          left: 60,
          right: 60,
          bottom: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: child,
          ),
        ),
        Positioned(
          top: 30,
          left: 30,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: backgroundColor, width: 2),
            ),
            child: Button(
              color: secondaryColor,
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(50),
              icon: CustomIcon(
                name: 'close',
                color: backgroundColor,
                size: 40,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
