import 'package:auto_size_text/auto_size_text.dart';
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
                      color: CustomColors.orchid,
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
            border: Border.all(color: CustomColors.orchid),
            borderRadius: BorderRadius.circular(10)),
        child: all8Pix(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: AutoSizeText(label, style: wineBoldStyle(size: 28)),
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
                                backgroundColor: CustomColors.orchid,
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
                            backgroundColor: CustomColors.orchid,
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
        AutoSizeText(label),
        const Divider(
          thickness: 5,
          color: CustomColors.orchid,
        )
      ]));
}

Widget rankingHeaders(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.05,
        child: Center(
          child: Text('Rank', style: wineBoldStyle()),
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        child: Center(
          child: Text('Student #', style: wineBoldStyle()),
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Center(
          child: Row(
            children: [
              Text('Student Name', style: wineBoldStyle()),
            ],
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Center(
          child: Text('Average Score', style: wineBoldStyle()),
        ),
      )
    ]),
  );
}

Widget studentQuizRankingEntry(BuildContext context,
    {required int index,
    required String quizTitle,
    required Map<dynamic, dynamic> studentData}) {
  double totalScore = 0;
  double averageScore = 0;
  Map<dynamic, dynamic> quizCategory =
      studentData['customQuizResults'][quizTitle];
  quizCategory.forEach((difficultyKey, difficultyValue) {
    totalScore += (difficultyValue as Map<dynamic, dynamic>)['score'];
  });
  averageScore = (totalScore) / quizCategory.length;
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
      decoration: BoxDecoration(
          color: CustomColors.mercury,
          border: Border.all(color: CustomColors.orchid, width: 3),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
            child: Center(
              child: (index + 1) < 4
                  ? Image.asset(
                      index == 0
                          ? 'assets/images/medals/gold.png'
                          : index == 1
                              ? 'assets/images/medals/silver.png'
                              : 'assets/images/medals/bronze.png',
                      scale: 15)
                  : Text('${(index + 1).toString()}', style: wineBoldStyle()),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Center(
              child: Text(studentData['studentID'], style: wineBoldStyle()),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Center(
              child: Row(
                children: [
                  Text('${studentData['firstName']} ${studentData['lastName']}',
                      style: wineBoldStyle()),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Center(
              child:
                  Text(averageScore.toStringAsFixed(2), style: wineBoldStyle()),
            ),
          )
        ]),
      ),
    ),
  );
}

Widget studentSpeechRankingEntry(BuildContext context,
    {required int index,
    required String currentSpeechLevelReq,
    required Map<dynamic, dynamic> studentData}) {
  double sum = 0;
  List<dynamic> confidenceScores =
      studentData['speechResults'][currentSpeechLevelReq]['confidenceScores'];
  for (var value in confidenceScores) {
    sum += value['average'];
  }
  double average = sum / confidenceScores.length;
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
      decoration: BoxDecoration(
          color: CustomColors.mercury,
          border: Border.all(color: CustomColors.orchid, width: 3),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
            child: Center(
              child: (index + 1) < 4
                  ? Image.asset(
                      index == 0
                          ? 'assets/images/medals/gold.png'
                          : index == 1
                              ? 'assets/images/medals/silver.png'
                              : 'assets/images/medals/bronze.png',
                      scale: 15)
                  : Text('${(index + 1).toString()}', style: wineBoldStyle()),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Center(
              child: Text(studentData['studentID'], style: wineBoldStyle()),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Center(
              child: Row(
                children: [
                  Text('${studentData['firstName']} ${studentData['lastName']}',
                      style: wineBoldStyle()),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Center(
              child: Text('${average.toStringAsFixed(2)}%',
                  style: wineBoldStyle()),
            ),
          )
        ]),
      ),
    ),
  );
}
