import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/models/achievement_model.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
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
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              all8Pix(Row(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(studentID, style: whiteBoldStyle(size: 30)),
                          Text(studentName, style: whiteBoldStyle(size: 30)),
                        ],
                      )),
                ],
              )),
              Container(
                color: CustomColors.love,
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    all8Pix(Text(
                        'Current Quizzes Taken: ${quizzesTaken.toString()}',
                        style: wineBoldStyle(size: 30))),
                    all8Pix(Text(
                        'Current SpeechLab Level: ${speechLabLevel.toString()}',
                        style: wineBoldStyle(size: 30))),
                    //  STUDENT NAME
                    earnedAchievements.isEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 53, 1, 36),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: all20Pix(Text(
                                'This student has not yet earned any achievements.',
                                textAlign: TextAlign.center,
                                style: whiteBoldStyle(size: 40))))
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 53, 1, 36),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text('ACHIEVEMENTS',
                                            textAlign: TextAlign.center,
                                            style: whiteBoldStyle(size: 30))),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                          earnedAchievements.length, (index) {
                                        var achievement = earnedAchievements
                                            .values
                                            .toList()[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: 165,
                                              decoration: const BoxDecoration(
                                                  color: CustomColors.wine,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        achievement.imagePath ==
                                                                null
                                                            ? Icon(
                                                                achievement
                                                                    .icon,
                                                                size: 60,
                                                                color: Colors
                                                                    .white)
                                                            : Image.asset(
                                                                achievement
                                                                    .imagePath!,
                                                                scale: 7),
                                                        Text(
                                                          earnedAchievements
                                                              .keys
                                                              .toList()[index],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: whiteBoldStyle(
                                                              size: 25),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 30),
                                                    child: Text(
                                                        achievement.description,
                                                        style: whiteBoldStyle(
                                                            size: 20)),
                                                  )
                                                ],
                                              )),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                width: 150,
                height: 70,
                child: all8Pix(ElevatedButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.love),
                    child: Text('CLOSE', style: wineBoldStyle()))),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
