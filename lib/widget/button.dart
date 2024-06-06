import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// A customizable button widget that can display an icon and optional text.
///
/// The [Button] widget allows for flexible customization of its appearance and behavior.
/// It supports displaying an icon with optional text, which can be arranged either in a single line or across multiple lines.
///  The [icon] and [onPressed] parameters are required. The [color], [borderRadius], [text],
/// [padding], [bold], and [multiLine] parameters are optional and have default values.
class Button extends StatelessWidget {
  /// The icon to be displayed inside the button.
  final CustomIcon icon;

  /// The background color of the button.
  final Color color;

  /// The border radius of the button.
  final BorderRadius borderRadius;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// Optional text to be displayed under the icon.
  final String? text;

  /// The padding inside the button.
  final EdgeInsets padding;

  /// Set the text to bold.
  final bool bold;

  /// Set the button in multi-line mode. The icon will be above the text.
  final bool multiLine;

  const Button({
    super.key,
    required this.icon,
    this.color = Colors.transparent,
    this.borderRadius = BorderRadius.zero,
    required this.onPressed,
    this.text,
    this.padding = EdgeInsets.zero,
    this.bold = false,
    this.multiLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        child: text != null
            ? !multiLine
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      SizedBox(width: spaceBetweenWidgets),
                      Text(text!, style: buttonText),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: spaceBetweenWidgets),
                      icon,
                      SizedBox(height: spaceBetweenWidgets),
                      Text(
                        text!,
                        textAlign: TextAlign.center,
                        style: bold ? buttonTextBold : buttonText,
                      ),
                    ],
                  )
            : Padding(
                padding: padding,
                child: icon,
              ),
      ),
    );
  }
}
