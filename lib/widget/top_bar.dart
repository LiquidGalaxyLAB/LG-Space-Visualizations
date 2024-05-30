import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:lg_space_visualizations/widget/button.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height = barHeight + spaceBetweenWidgets;

  TopBar({super.key, required this.title});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            top: spaceBetweenWidgets,
            left: spaceBetweenWidgets,
            right: spaceBetweenWidgets),
        child: Row(children: [
          Expanded(
              flex: 1, // 8.3% of space
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: backgroundColor,
                  ),
                  child: Center(
                    child: Button(
                        color: backgroundColor,
                        icon: CustomIcon(
                            name: 'back',
                            width: 50,
                            height: 50,
                            color: primaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ))),
          SizedBox(width: spaceBetweenWidgets),
          Expanded(
              flex: 11, // 91.7% of space
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: backgroundColor,
                  ),
                  child: Center(
                      child: Text(
                        title,
                        style: bigTitle,
                      )))),
        ]));
  }
}
