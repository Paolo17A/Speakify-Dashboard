import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';

import 'custom_padding_widgets.dart';
import 'custom_text_widgets.dart';

Widget speechLabLogo({double? size}) {
  return CircleAvatar(
    radius: size,
    backgroundColor: Colors.transparent,
    child: Image.asset('assets/images/speechlab_logo.png'),
  );
}

Widget speechLabLogoWithText(BuildContext context) {
  return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            speechLabLogo(size: 50),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: const Center(
                child: Text(
                  'SPEAKIFY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: CustomColors.plum,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
              ),
            )
          ],
        ),
      ));
}

Widget authenticationDesignImages(BuildContext context) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.78,
      child: Column(
        children: [
          speechLabLogoWithText(context),
          Expanded(child: Image.asset('assets/images/dashboard_welcome.png')),
        ],
      ));
}

Widget lessonEntryWithActionsContainer(BuildContext context,
    {required String label,
    required Function editFunction,
    required Function deleteFunction,
    required bool mayEditLesson,
    double? height = 60}) {
  return SizedBox(
    width: double.infinity,
    height: height,
    child: Container(
        decoration: BoxDecoration(
            color: CustomColors.mercury,
            border: Border.all(color: CustomColors.wine),
            borderRadius: BorderRadius.circular(10)),
        child: all8Pix(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: cambriaText(
                  text: label,
                  textStyle: const TextStyle(
                      color: CustomColors.wine,
                      fontWeight: FontWeight.bold,
                      fontSize: 28)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 55,
                    child: mayEditLesson
                        ? ElevatedButton(
                            onPressed: () => editFunction(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.wine,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60))),
                            child: const Icon(Icons.edit))
                        : null,
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                        onPressed: () => deleteFunction(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.wine,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60))),
                        child: const Icon(Icons.delete)),
                  )
                ],
              ),
            )
          ],
        ))),
  );
}

Widget pageHeaderWithDivider(BuildContext context, {required String label}) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(children: [
        cambriaWineHeaderText(text: label),
        const Divider(
          thickness: 5,
          color: CustomColors.darkWine,
        )
      ]));
}
