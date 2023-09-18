import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/models/speech_model.dart';
import 'package:speechlab_dashboard/screens/selected_quiz_screen.dart';
import 'package:speechlab_dashboard/screens/selected_speechlab_screen.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../models/lesson_model.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  bool _viewingQuizScores = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(children: [
          lefNavigator(context, 0),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                  child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Center(
                                  child: Column(children: [
                                Text(
                                    _viewingQuizScores
                                        ? 'ALL QUIZ LESSONS'
                                        : 'ALL SPEECHLAB LEVELS',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 60, 19, 97),
                                        fontSize: 70,
                                        fontWeight: FontWeight.bold)),
                                const Divider(thickness: 3)
                              ]))),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 60,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _viewingQuizScores = !_viewingQuizScores;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: Text(
                                      _viewingQuizScores
                                          ? 'VIEW SPEECHLAB SCORES'
                                          : 'VIEW QUIZ SCORES',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20))))
                        ])),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: _viewingQuizScores
                        ? Wrap(
                            spacing: MediaQuery.of(context).size.width * 0.05,
                            runSpacing:
                                MediaQuery.of(context).size.width * 0.05,
                            children: allLessons.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final LessonModel lesson = entry.value;

                              return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectedQuizScreen(
                                                        currentQuizLevelReq:
                                                            index + 1,
                                                        selectedQuiz: lesson)));
                                      },
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                    'Lesson ${index + 1}',
                                                    style: const TextStyle(
                                                        fontSize: 34,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Expanded(
                                                child: Center(
                                                    child: Text(lesson.title,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            fontSize: 25))))
                                          ])));
                            }).toList(),
                          )
                        : Wrap(
                            spacing: MediaQuery.of(context).size.width * 0.05,
                            runSpacing:
                                MediaQuery.of(context).size.width * 0.05,
                            children:
                                speechCategories.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final SpeechModel level = entry.value;

                              return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectedSpeechLabScreen(
                                                        currentSpeechLevelReq:
                                                            index + 1,
                                                        selectedLevel: level)));
                                      },
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                    'Level ${index + 1}',
                                                    style: const TextStyle(
                                                        fontSize: 34,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Expanded(
                                                child: Center(
                                                    child: Text(level.category,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            fontSize: 25))))
                                          ])));
                            }).toList(),
                          ))
              ])))
        ]));
  }
}
