import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// A Widget that displays a loading indicator with a [message]
class LoadingIndicator extends StatelessWidget {
  // Message to display below the loading indicator
  final String message;

  const LoadingIndicator({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 80,
          width: 80,
          child: CircularProgressIndicator(),
        ),
        SizedBox(height: spaceBetweenWidgets),
        Text(
          message,
          style: middleText,
        ),
      ],
    );
  }
}
