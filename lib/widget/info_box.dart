import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// [InfoBox] is a widget that displays formatted information
/// along with a [subText] description in a column layout.
///
/// The [text] and [subText] parameters are required.
class InfoBox extends StatelessWidget {
  final String text;
  final String subText;

  const InfoBox({super.key, required this.text, required this.subText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: middleTitle),
        Transform.translate(
          offset: const Offset(0, -10),
          child: Text(subText, style: smallText),
        ),
      ],
    );
  }
}
