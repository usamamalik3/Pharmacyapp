import 'package:flutter/material.dart';

import 'constraint.dart';

class Regformwidget extends StatefulWidget {
  final TextInputType textInputType;
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final Function functionValidate;
  final TextInputAction actionKeyboard;
  final Widget? suffixicon;

  const Regformwidget({
    Key? key,
    this.suffixicon,
    required this.textInputType,
    required this.labelText,
    required this.obscureText,
    required this.controller,
    required this.functionValidate,
    required this.actionKeyboard,
  }) : super(key: key);

  @override
  State<Regformwidget> createState() => _RegformwidgetState();
}

class _RegformwidgetState extends State<Regformwidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        cursorColor: primarycolor,
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        textInputAction: widget.actionKeyboard,
        style: TextStyle(
          color: textsecondarycolor,
          fontSize: 18.0,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: 1.2,
        ),
        decoration: InputDecoration(
          suffixIcon: widget.suffixicon,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: primarycolor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primarycolor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primarycolor),
          ),
          contentPadding: const EdgeInsets.only(
              top: 15, bottom: 12, left: 10.0, right: 8.0),
          isDense: true,
          errorStyle: TextStyle(
            color: textsecondarycolor,
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primarycolor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primarycolor),
          ),
        ),
        controller: widget.controller,
      ),
    );
  }
}
