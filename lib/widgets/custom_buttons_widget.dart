import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
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
        style: ElevatedButton.styleFrom(backgroundColor: CustomColors.jam),
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
              backgroundColor: CustomColors.orchid,
              side: const BorderSide(color: CustomColors.wine, width: 2)),
          child: AutoSizeText(label, style: whiteBoldStyle(size: 30)),
        )),
  );
}

Widget scoreOptionButton(BuildContext context,
    {required String label,
    required bool isSelected,
    required Function onPress}) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      height: 60,
      child: ElevatedButton(
          onPressed: () => onPress(),
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelected ? CustomColors.mercury : CustomColors.orchid,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: AutoSizeText(label,
              style: TextStyle(
                  color:
                      isSelected ? CustomColors.orchid : CustomColors.mercury,
                  fontWeight: FontWeight.bold,
                  fontSize: 20))));
}

Widget longEntryButton(BuildContext context,
    {required String label,
    required Function onPress,
    double? width = double.infinity,
    double? height = 80}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height,
    child: ElevatedButton(
        onPressed: () => onPress(),
        style: ElevatedButton.styleFrom(
            side: const BorderSide(color: CustomColors.wine),
            backgroundColor: CustomColors.mercury),
        child: all8Pix(Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: AutoSizeText(label, style: wineBoldStyle(size: 28)),
            )
          ],
        ))),
  );
}

Widget shortEntryButton(BuildContext context,
    {required int lessonIndex,
    required String lessonName,
    required Function onPress,
    double? height = 100}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.35,
    height: height,
    child: ElevatedButton(
      onPressed: () => onPress(),
      style: ElevatedButton.styleFrom(
          side: const BorderSide(color: CustomColors.wine),
          backgroundColor: CustomColors.mercury),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              AutoSizeText('Lesson $lessonIndex: $lessonName',
                  style: wineBoldStyle(size: 28)),
            ],
          )),
    ),
  );
}

Widget addEntryButton(BuildContext context, {required Function onPress}) {
  return vertical10PixHorizontal30Pix(
    context,
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 75,
      child: ElevatedButton(
          onPressed: () => onPress(),
          style: ElevatedButton.styleFrom(backgroundColor: CustomColors.wine),
          child:
              AutoSizeText('ADD NEW LESSON', style: whiteBoldStyle(size: 30))),
    ),
  );
}
