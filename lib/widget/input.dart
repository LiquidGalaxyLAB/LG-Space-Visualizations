import 'package:flutter/material.dart';
import 'package:lg_space_visualizations/widget/button.dart';
import 'package:lg_space_visualizations/utils/styles.dart';
import 'package:lg_space_visualizations/widget/custom_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A custom [Input] widget that supports secure text entry and saves input to shared preferences.
///
/// The [hintText], [inputType], [controller], and [id] parameters are required.
/// The [secure] parameter defaults to `false` and an optional [onSubmitted] callback function can be provided.
class Input extends StatefulWidget {
  /// The hint text to display in the input field.
  final String hintText;

  /// The type of keyboard to use for the input field.
  final TextInputType inputType;

  /// The controller to manage the input field's text.
  final TextEditingController controller;

  /// Whether the input field should have an obscure function.
  final bool secure;

  /// The unique identifier for saving the input field's value to shared preferences.
  final String id;

  /// The callback function to be executed when the input field is submitted.
  /// If not provided, an empty function is used.
  final void Function(String)? onSubmitted;

  const Input({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.controller,
    required this.id,
    this.secure = false,
    this.onSubmitted,
  });

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  /// Indicates whether the text should be hidden.
  bool hide = false;

  /// Initializes the state of the widget.
  ///
  /// Sets the [hide] variable to the value of the [secure] property of the widget.
  @override
  void initState() {
    super.initState();
    hide = widget.secure;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.inputType,
        obscureText: hide,
        onChanged: (text) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (widget.controller.text.isNotEmpty) {
            prefs.setString(widget.id, widget.controller.text);
          } else {
            prefs.remove(widget.id);
          }
        },
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          suffixIcon: widget.secure
              ? Button(
            icon: CustomIcon(
              size: 10,
              name: hide ? "see" : "hide",
              color: secondaryColor,
            ),
            color: Colors.transparent,
            onPressed: () {
              setState(() {
                hide = !hide;
              });
            },
            padding: const EdgeInsets.all(10),
          )
              : null,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: widget.hintText,
          filled: true,
          fillColor: grey,
          contentPadding: const EdgeInsets.only(
              left: 20.0, top: 15.0, bottom: 15.0, right: 20.0),
          hintStyle: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
