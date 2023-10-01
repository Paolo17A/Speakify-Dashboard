// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SpeechLabTextField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType textInputType;
  const SpeechLabTextField(
      {super.key,
      required this.text,
      required this.controller,
      required this.textInputType});

  @override
  State<SpeechLabTextField> createState() => _SpeechLabTextFieldState();
}

class _SpeechLabTextFieldState extends State<SpeechLabTextField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.textInputType == TextInputType.visiblePassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.controller,
        obscureText: isObscured,
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black.withOpacity(0.9)),
        decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: widget.text,
            labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontStyle: FontStyle.italic),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.white.withOpacity(0.4),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.black, width: 3.0)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            suffixIcon: widget.textInputType == TextInputType.visiblePassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    icon: Icon(
                      isObscured ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black.withOpacity(0.6),
                    ))
                : null),
        keyboardType: widget.textInputType,
        maxLines: widget.textInputType == TextInputType.multiline ? 6 : 1);
  }
}

TextField speechLabTextField(String text, TextEditingController controller,
    TextInputType textInputType) {
  bool isPassword = textInputType == TextInputType.visiblePassword;
  bool isObscured = isPassword;
  return TextField(
      controller: controller,
      obscureText: isObscured,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: text,
          labelStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontStyle: FontStyle.italic),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.4),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.black, width: 3.0)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    isObscured = !isObscured;
                  },
                  icon: Icon(
                    isPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black.withOpacity(0.6),
                  ))
              : null),
      keyboardType: textInputType,
      maxLines: textInputType == TextInputType.multiline ? 9 : 1);
}
