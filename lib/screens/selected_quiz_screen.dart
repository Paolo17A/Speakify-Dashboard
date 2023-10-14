import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speechlab_dashboard/models/lesson_model.dart';
import 'package:speechlab_dashboard/utils/student_quiz_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

class SelectedQuizScreen extends StatefulWidget {
  final int currentQuizLevelReq;
  final LessonModel selectedQuiz;
  const SelectedQuizScreen(
      {super.key,
      required this.currentQuizLevelReq,
      required this.selectedQuiz});

  @override
  State<SelectedQuizScreen> createState() => _SelectedQuizScreenState();
}

class _SelectedQuizScreenState extends State<SelectedQuizScreen> {
  bool _isLoading = true;
  List<DocumentSnapshot> _userDocs = [];
  Map<String, dynamic> allQuestions = {};
  @override
  void initState() {
    super.initState();
    _getAllEligibleUsers();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _loadQuiz();
  }

  void _getAllEligibleUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    _userDocs = querySnapshot.docs.where((userDoc) {
      final data = userDoc.data() as Map<dynamic, dynamic>;
      return data.containsKey('userType') &&
          data['userType'] == 'STUDENT' &&
          data.containsKey('currentLesson') &&
          data['currentLesson'] >= widget.currentQuizLevelReq;
    }).toList();

    setState(() {
      _isLoading = false;
    });
  }

  Future _loadQuiz() async {
    //  Handle converting JSON data to a List<dynamic>
    String jsonData = await rootBundle
        .loadString(allLessons[widget.currentQuizLevelReq - 1].quizPath);
    allQuestions = json.decode(jsonData);
  }

  bool _hasAnsweredThisQuiz(
      Map<dynamic, dynamic> selectedQuiz, String difficulty) {
    return selectedQuiz.containsKey(widget.currentQuizLevelReq.toString()) &&
        (selectedQuiz[widget.currentQuizLevelReq.toString()]
                as Map<dynamic, dynamic>)
            .containsKey(difficulty);
  }

  String _getQuizScoreFormatted(
      Map<dynamic, dynamic> selectedQuiz, String difficulty) {
    Map<dynamic, dynamic> quizData =
        selectedQuiz[widget.currentQuizLevelReq.toString()];
    final difficultyScore = quizData[difficulty]['score'];
    final questionCount =
        (quizData[difficulty]['answers'] as List<dynamic>).length;
    return '$difficultyScore / $questionCount';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(children: [
          lefNavigator(context, 0),
          bodyWidgetWhiteBG(
              context,
              switchedLoadingContainer(
                  _isLoading,
                  SingleChildScrollView(
                    child: all8Pix(Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(widget.selectedQuiz.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 60, 19, 97),
                                fontSize: 70,
                                fontWeight: FontWeight.bold)),
                      ),
                      _userDocs.isNotEmpty
                          ? Column(children: [
                              Container(
                                  color: const Color.fromARGB(255, 82, 48, 124),
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.30,
                                                child: Text('Student Name',
                                                    style: _headerStyle())),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child: Text('Easy Quiz',
                                                    textAlign: TextAlign.center,
                                                    style: _headerStyle())),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child: Text('Average Quiz',
                                                    textAlign: TextAlign.center,
                                                    style: _headerStyle())),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child: Text('Difficult Quiz',
                                                    textAlign: TextAlign.center,
                                                    style: _headerStyle()))
                                          ]))),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _userDocs.length,
                                  itemBuilder: (context, index) {
                                    Map<dynamic, dynamic> quizResults =
                                        (_userDocs[index].data()! as Map<
                                            dynamic, dynamic>)['quizResults'];
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Container(
                                            height: 75,
                                            color: const Color.fromARGB(
                                                255, 103, 65, 150),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                          child: Text(
                                                              '${(_userDocs[index].data()! as Map<dynamic, dynamic>)['firstName']} ${(_userDocs[index].data()! as Map<dynamic, dynamic>)['lastName']}',
                                                              style:
                                                                  _studentEntryStyle())),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          child: _hasAnsweredThisQuiz(
                                                                  quizResults,
                                                                  'EASY')
                                                              ? _quizResultEntry(
                                                                  _userDocs[
                                                                      index],
                                                                  'EASY')
                                                              : _notAvailable()),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          child: _hasAnsweredThisQuiz(
                                                                  quizResults,
                                                                  'AVERAGE')
                                                              ? _quizResultEntry(
                                                                  _userDocs[
                                                                      index],
                                                                  'AVERAGE')
                                                              : _notAvailable()),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          child: _hasAnsweredThisQuiz(
                                                                  quizResults,
                                                                  'DIFFICULT')
                                                              ? _quizResultEntry(
                                                                  _userDocs[
                                                                      index],
                                                                  'DIFFICULT')
                                                              : _notAvailable())
                                                    ]))));
                                  })
                            ])
                          : const Expanded(
                              child: Center(
                                  child: Text(
                                      'No student has done this lesson yet')))
                    ])),
                  )))
        ]));
  }

  TextStyle _headerStyle() {
    return const TextStyle(
        fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
  }

  TextStyle _studentEntryStyle() {
    return const TextStyle(fontSize: 20, color: Colors.white);
  }

  Text _notAvailable() {
    return Text('N/A',
        textAlign: TextAlign.center, style: _studentEntryStyle());
  }

  Widget _quizResultEntry(DocumentSnapshot selectedDoc, String difficulty) {
    String profileImageURL =
        (selectedDoc.data()! as Map<dynamic, dynamic>)['profileImageURL'];
    String studentName =
        '${(selectedDoc.data()! as Map<dynamic, dynamic>)['firstName']} ${(selectedDoc.data()! as Map<dynamic, dynamic>)['lastName']}';
    Map<dynamic, dynamic> quizResults =
        (selectedDoc.data()! as Map<dynamic, dynamic>)['quizResults'];
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(_getQuizScoreFormatted(quizResults, difficulty),
          style: _studentEntryStyle()),
      ElevatedButton(
          onPressed: () => displayQuizAnswersDialogue(
              difficulty,
              context,
              allQuestions[difficulty.toLowerCase()],
              quizResults[widget.currentQuizLevelReq.toString()][difficulty]
                  ['answers'],
              profileImageURL,
              studentName,
              quizResults[widget.currentQuizLevelReq.toString()][difficulty]
                  ['score']),
          child: const Text('VIEW ANSWERS',
              textAlign: TextAlign.center, style: TextStyle(letterSpacing: 2)))
    ]);
  }
}
