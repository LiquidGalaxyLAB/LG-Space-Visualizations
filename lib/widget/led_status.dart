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

  /// Indicates if the LED is enabled.
  final bool enable;

  const LedStatus({
    super.key,
    required this.status,
    required this.size,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enable
            ? status
                ? Colors.green
                : Colors.red
            : Colors.grey,
        border: Border.all(
          color: secondaryColor,
          width: 2.5,
        ),
      ),
    );
  }
}
