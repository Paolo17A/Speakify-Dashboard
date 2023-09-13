import 'package:flutter/material.dart';

void displayError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 15),
      ),
      backgroundColor: const Color.fromARGB(255, 86, 134, 133)));
}
