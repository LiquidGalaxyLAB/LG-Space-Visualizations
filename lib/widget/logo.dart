import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';

/// A widget that displays the application's logo.
///
/// The [Logo] widget shows an [image] with the name of the application.
class Logo extends StatelessWidget {
  /// The image to be displayed as the logo.
  ///
  /// Defaults to `assets/images/logo.png`.
  final AssetImage image;

  const Logo(
      {super.key, this.image = const AssetImage('assets/images/logo.png')});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(image: image, height: 200),
        Text("Space Visualizations", style: hugeTitle),
        Transform.translate(
          offset: const Offset(0, -25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: backgroundColor,
                height: 10,
                width: 175,
                margin: const EdgeInsets.only(right: 25),
              ),
              Text(
                "for Liquid Galaxy",
                style: bigTitle.apply(color: backgroundColor),
              ),
              Container(
                color: backgroundColor,
                height: 10,
                width: 175,
                margin: const EdgeInsets.only(left: 25),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
