import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// A widget that displays a circular LED indicator.
///
/// The [LedStatus] widget represents an LED that indicates the connection status with the Liquid Galaxy and the application.
/// You can customize it with the required parameters [size] (diameter) and [status] (on/off).
class LedStatus extends StatelessWidget {
  /// Indicates the LED status (true -> connected, false -> not connected).
  final bool status;

  /// The size of the LED.
  final double size;

  const LedStatus({
    Key? key,
    required this.status,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status ? Colors.green : Colors.red,
        border: Border.all(
          color: secondaryColor,
          width: 2.5,
        ),
      ),
    );
  }
}
