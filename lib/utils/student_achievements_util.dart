import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/models/achievement_model.dart';

void displayStudentAchievementsDialogue(
    BuildContext context,
    String studentName,
    List<String> achievements,
    String profileImageURL) async {
  Map<String, AchievementModel> earnedAchievements = {};
  for (int i = 0; i < achievements.length; i++) {
    earnedAchievements[achievements[i]] = getAchievement(achievements[i])!;
  }
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 60, 19, 97),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            //  PROFILE IMAGE
            profileImageURL == ''
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
            //  STUDENT NAME
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  studentName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                )),
            earnedAchievements.isEmpty
                ? Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 53, 1, 36),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                            'This student has not yet earned any achievements.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold))),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 53, 1, 36),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('ACHIEVEMENTS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(earnedAchievements.length,
                                (index) {
                              var achievement =
                                  earnedAchievements.values.toList()[index];
                              return Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 145,
                                    decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 53, 1, 36),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              achievement.imagePath == null
                                                  ? Icon(achievement.icon,
                                                      size: 60,
                                                      color: Colors.white)
                                                  : Image.asset(
                                                      achievement.imagePath!,
                                                      scale: 6,
                                                    ),
                                              Text(
                                                earnedAchievements.keys
                                                    .toList()[index],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Text(achievement.description,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
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
          ],
        ),
      ),
    ),
  );
}
