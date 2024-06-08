import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// A [CustomDialog] widget that displays a [title], an optional [content] message, and an [CustomIcon] defined from [iconName].
///
/// The dialog also includes a "Back" button that closes the dialog when pressed.
class CustomDialog extends StatelessWidget {
  /// The title text to display in the dialog.
  final String title;

  /// The content text to display in the dialog. Can be null.
  final String? content;

  /// The name of the icon to display next to the title.
  final String iconName;

  const CustomDialog({
    super.key,
    required this.title,
    this.content,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          CustomIcon(
            name: iconName,
            width: 30,
            height: 30,
            color: secondaryColor,
          ),
          const SizedBox(width: 10),
          Text(title, style: middleTitle),
        ],
      ),
      content: content != null ? Text(content!, style: middleText) : null,
      actions: <Widget>[
        SizedBox(
          height: 50,
          child: Button(
            icon: CustomIcon(
              name: 'back',
              width: 30,
              height: 30,
              color: backgroundColor,
            ),
            text: 'Back',
            color: secondaryColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ],
    );
  }
}
