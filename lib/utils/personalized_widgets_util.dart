import 'package:flutter/material.dart';

Widget homeDashboardRowButton(
    double width, double height, Function onPress, String label) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: () => onPress,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )),
  );
}
