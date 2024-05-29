import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/bottom_bar.dart';
import 'package:lg_space_visualizations/widget/top_bar.dart';

class TemplatePage extends StatefulWidget {
  final List<Widget> children;
  final String title;
  final bool showTopBar;

  const TemplatePage(
      {super.key,
      required this.title,
      this.showTopBar = true,
      required this.children});

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
            )),
        bottomNavigationBar: const BottomBar());
  }
}
