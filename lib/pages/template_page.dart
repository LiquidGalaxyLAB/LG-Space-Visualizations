import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/bottom_bar.dart';
import 'package:lg_space_visualizations/widget/top_bar.dart';

/// A page template that includes an optional top bar and a bottom bar.
///
/// The [TemplatePage] widget allows you to specify a [title] and [children]
/// widgets to be displayed. The top bar visibility can be controlled with [showTopBar].
class TemplatePage extends StatefulWidget {
  /// The title of the page displayed in the top bar.
  final String title;

  /// The widgets to be displayed in the body of the page.
  final List<Widget> children;

  /// Controls the visibility of the top bar.
  final bool showTopBar;

  const TemplatePage({
    Key? key,
    required this.title,
    this.showTopBar = true,
    required this.children,
  }) : super(key: key);

  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: widget.showTopBar ? TopBar(title: widget.title) : null,
      body: Padding(
        padding: EdgeInsets.all(spaceBetweenWidgets),
        child: Row(
          children: widget.children,
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
