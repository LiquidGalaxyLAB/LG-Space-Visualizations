import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/pages/template_page.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// [WebPage] is a widget that displays a web page
/// within a [WebView] inside a [TemplatePage].
///
/// The required [url] parameter specifies the web page to load,
/// and the required [title] parameter specifies the title of the page.
class WebPage extends StatefulWidget {
  final String url;
  final String title;

  const WebPage({super.key, required this.url, required this.title});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      // Enables JavaScript.
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // Sets the background color.
      ..setBackgroundColor(backgroundColor)
      // Loads the URL passed to the widget.
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: widget.title,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
                color: backgroundColor,
                child: WebViewWidget(
                  controller: controller,
                )),
          ),
        ),
      ],
    );
  }
}
