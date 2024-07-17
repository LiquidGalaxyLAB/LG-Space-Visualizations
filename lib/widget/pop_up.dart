import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';

/// A Widget that displays a popup with a [child] widget and an optional [onPressed] callback.
class PopUp extends StatelessWidget {
  /// Child widget to be displayed inside the popup
  final Widget child;

  /// The callback function to be executed when the close button is pressed.
  /// If no callback is provided, it will default to popping the current route.
  final VoidCallback? onPressed;

  const PopUp({super.key, required this.child, this.onPressed});

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
              onPressed: onPressed ?? () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}
