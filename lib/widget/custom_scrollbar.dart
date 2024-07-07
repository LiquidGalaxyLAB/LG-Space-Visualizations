import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// A Widget that displays a custom scrollbar around a [child] widget. The child should be a scrollable widget like a list or a grid.
class CustomScrollbar extends StatelessWidget {
  final Widget child;

  const CustomScrollbar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      // Color of the scrollbar thumb
      thumbColor: secondaryColor,

      // Thickness of the scrollbar
      thickness: 15,

      // Padding around the scrollbar
      padding: EdgeInsets.only(
        top: spaceBetweenWidgets / 2,
        left: spaceBetweenWidgets / 2,
        right: spaceBetweenWidgets / 2,
        bottom: spaceBetweenWidgets / 2,
      ),

      // Whether the track should be visible
      trackVisibility: true,

      // Radius of the scrollbar track corners
      trackRadius: Radius.circular(borderRadius),

      // Color of the scrollbar track with opacity
      trackColor: secondaryColor.withOpacity(0.3),

      // Whether the scrollbar thumb should be visible
      thumbVisibility: true,

      // Minimum length of the scrollbar thumb
      minThumbLength: 70,

      // Margin across the scrollbar axis
      crossAxisMargin: 5,

      // Margin along the main axis of the scrollbar
      mainAxisMargin: 5,

      // Border color of the scrollbar track
      trackBorderColor: Colors.transparent,

      // Radius of the scrollbar thumb corners
      radius: Radius.circular(borderRadius),
      child: child,
    );
  }
}
