import 'package:flutter/material.dart';

Padding vertical10PercentHorizontal10Percent(BuildContext context,
    {required Widget child}) {
  return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1,
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: child);
}

Padding vertical10PixHorizontal30Pix(BuildContext context,
    {required Widget child}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: child);
}

Padding all8Pix(Widget child) {
  return Padding(padding: const EdgeInsets.all(8), child: child);
}

Padding all20Pix(Widget child) {
  return Padding(padding: const EdgeInsets.all(20), child: child);
}
