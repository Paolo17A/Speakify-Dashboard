// ignore_for_file: file_names

import 'package:flutter/material.dart';

TextField speechLabTextField(String text, TextEditingController controller,
    TextInputType textInputType) {
  return TextField(
      controller: controller,
      obscureText: textInputType == TextInputType.visiblePassword,
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
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
      keyboardType: textInputType,
      maxLines: textInputType == TextInputType.multiline ? 9 : 1);
}
