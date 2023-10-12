import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

import '../utils/color_util.dart';

Widget authenticationButton(String label, Function onPress,
    {double height = 50, double width = 150}) {
  return SizedBox(
    height: height,
    width: width,
    child: ElevatedButton(
        onPressed: () {
          onPress();
        },
        child: Text(label, style: whiteBoldStyle(size: 20))),
  );
}

Widget homeDashboardRowButton(
    double width, double height, Function onPress, String label) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: () {
            onPress();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.lavender,
              side: const BorderSide(color: CustomColors.lilac, width: 2)),
          child: Text(label,
              textAlign: TextAlign.center, style: blackBoldStyle(size: 30)),
        )),
  );
}
