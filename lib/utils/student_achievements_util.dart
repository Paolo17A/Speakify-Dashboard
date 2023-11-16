import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/models/achievement_model.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

void displayStudentAchievementsDialogue(
    BuildContext context,
    String studentID,
    String studentName,
    int quizzesTaken,
    int speechLabLevel,
    List<String> achievements,
    String profileImageURL) async {
  Map<String, AchievementModel> earnedAchievements = {};
  for (int i = 0; i < achievements.length; i++) {
    earnedAchievements[achievements[i]] = getAchievement(achievements[i])!;
  }
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: CustomColors.wine,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _studentBasicData(profileImageURL, studentID, studentName),
              loveWineContainer(
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            all8Pix(Text(
                                'Current Quizzes Taken: ${quizzesTaken.toString()}',
                                style: wineBoldStyle(size: 25))),
                          ],
                        ),
                        Row(
                          children: [
                            all8Pix(Text(
                                'Current SpeechLab Level: ${speechLabLevel.toString()}',
                                style: wineBoldStyle(size: 25))),
                          ],
                        ),
                        Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 0.25,
                          color: Color.fromARGB(255, 165, 115, 153),
                          child: all8Pix(Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AutoSizeText('ACHIEVEMENTS',
                                  style: whiteBoldStyle(size: 40)),
                              earnedAchievements.isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: List.generate(
                                        earnedAchievements.length,
                                        (index) {
                                          var achievement = earnedAchievements
                                              .values
                                              .toList()[index];
                                          return achievement.imagePath == null
                                              ? Container()
                                              : Image.asset(
                                                  achievement.imagePath!,
                                                  scale: 4);
                                        },
                                      )),
                                    )
                                  : all20Pix(Text(
                                      'This student has not yet earned any achievements.',
                                      textAlign: TextAlign.center,
                                      style: whiteBoldStyle(size: 30))),
                            ],
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: all8Pix(ElevatedButton(
                          onPressed: () => GoRouter.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.wine),
                          child: Text('CLOSE', style: whiteBoldStyle()))),
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.57,
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _studentBasicData(
  String profileImageURL,
  String studentID,
  String studentName,
) {
  return all8Pix(Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      //  PROFILE IMAGE
      profileImageURL.isEmpty
          ? const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 70,
                color: Color.fromARGB(255, 53, 1, 36),
              ))
          : CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(profileImageURL),
            ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(studentID, style: whiteBoldStyle(size: 30)),
              Text(studentName, style: whiteBoldStyle(size: 30)),
            ],
          )),
    ],
  ));
}
