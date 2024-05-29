import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

class Button extends StatelessWidget {
  final CustomIcon icon;
  final Color color;
  final BorderRadius borderRadius;
  final VoidCallback onPressed;
  final String? text;
  final EdgeInsets padding;

  // set to true if you want the text to be bold
  final bool bold;
  // set to true if you want the icon and text to be in different lines
  final bool multiLine;

  const Button(
      {super.key,
      required this.icon,
      this.color = Colors.transparent,
      this.borderRadius = BorderRadius.zero,
      required this.onPressed,
      this.text,
      this.padding = EdgeInsets.zero,
        this.bold = false,
      this.multiLine = false});

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
                        Text(text!, style: buttonText)
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: spaceBetweenWidgets),
                        icon,
                        SizedBox(height: spaceBetweenWidgets),
                        Text(text!,   textAlign: TextAlign.center,
                            style: bold ? buttonTextBold : buttonText)
                      ],
                    )
              : Padding(padding: padding, child: icon),
        ));
  }
}
