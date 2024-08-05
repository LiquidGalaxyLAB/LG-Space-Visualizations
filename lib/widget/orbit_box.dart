import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/orbit.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/button.dart';

/// A widget box for an [orbit]. It displays the orbit's gif and name.
class OrbitBox extends StatefulWidget {
  /// The [Orbit] instance.
  final Orbit orbit;

  const OrbitBox({super.key, required this.orbit});

  @override
  _OrbitBoxState createState() => _OrbitBoxState();
}

class _OrbitBoxState extends State<OrbitBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            setState(() {
              Navigator.pushNamed(context, '/orbit', arguments: widget.orbit);
            });
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    color: backgroundColor,
                    child: Image.asset(
                      "assets/gifs/${widget.orbit.id}.gif",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: spaceBetweenWidgets / 2,
                  right: spaceBetweenWidgets / 2,
                  bottom: spaceBetweenWidgets / 2,
                    child: Button(
                      icon: null,
                      onPressed: () {
                        setState(() {
                          Navigator.pushNamed(context, '/orbit', arguments: widget.orbit);
                        });
                      },
                      text: widget.orbit.orbitName,
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                  )),
            ],
          ),
        ));
  }
}
