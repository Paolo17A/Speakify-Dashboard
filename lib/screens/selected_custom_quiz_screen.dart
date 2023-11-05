import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/firebase_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../utils/color_util.dart';
import '../utils/student_quiz_util.dart';
import '../widgets/custom_text_widgets.dart';

class SelectedCustomQuizScreen extends StatefulWidget {
  final String quizTitle;
  //final String serializedQuizQuestions;
  const SelectedCustomQuizScreen({super.key, required this.quizTitle});

  @override
  State<SelectedCustomQuizScreen> createState() =>
      _SelectedCustomQuizScreenState();
}

class _SelectedCustomQuizScreenState extends State<SelectedCustomQuizScreen> {
  bool _isLoading = true;
  bool _isInitialized = false;
  bool _isAdmin = false;
  List<DocumentSnapshot> allEligibleUsers = [];
  Map<String, dynamic> allQuestions = {};

  @override
  void initState() {
    super.initState();
    //allQuestions = json.decode(widget.serializedQuizQuestions);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _isAdmin = await isAdmin();
    if (!_isInitialized) {
      await getSerializedQuizContent();
      _getEligibleUsers();
    }
  }

  Future getSerializedQuizContent() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      setState(() {
        _isLoading = true;
      });
      final quiz = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.quizTitle)
          .get();
      final quizData = quiz.data() as Map<dynamic, dynamic>;
      allQuestions = jsonDecode(quizData['quizContent']);
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Error getting serialized quiz content: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getEligibleUsers() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final eligibleUsers = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'STUDENT')
          .get();

      allEligibleUsers = eligibleUsers.docs.where((user) {
        Map<dynamic, dynamic> userData = user.data();
        return userData.containsKey('customQuizResults') &&
            (userData['customQuizResults'] as Map<dynamic, dynamic>)
                .containsKey(widget.quizTitle);
      }).toList();

      if (!_isAdmin) {
        final instructor = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        final instructorData = instructor.data() as Map<dynamic, dynamic>;
        List<dynamic> handledSections = instructorData['handledSections'];
        allEligibleUsers = allEligibleUsers.where((student) {
          final studentData = student.data() as Map<dynamic, dynamic>;
          return handledSections.contains(studentData['section']);
        }).toList();
      }

      setState(() {
        _isLoading = false;
        _isInitialized = true;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting eligible users: $error')));
    }
  }

  bool _hasAnsweredThisQuiz(
      Map<dynamic, dynamic> selectedQuiz, String difficulty) {
    return selectedQuiz.containsKey(widget.quizTitle) &&
        (selectedQuiz[widget.quizTitle] as Map<dynamic, dynamic>)
            .containsKey(difficulty);
  }

  String _getQuizScoreFormatted(
      Map<dynamic, dynamic> selectedQuiz, String difficulty) {
    Map<dynamic, dynamic> quizData = selectedQuiz[widget.quizTitle];
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
        lefNavigator(context, 0, isAdmin: _isAdmin),
        bodyWidgetWhiteBG(
            context,
            switchedLoadingContainer(
                _isLoading,
                all8Pix(SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(children: [
                            AutoSizeText(
                              widget.quizTitle,
                              style: wineBoldStyle(size: 70),
                            ),
                            const Divider(
                              thickness: 5,
                              color: CustomColors.darkWine,
                            )
                          ])),
                      loveWineContainer(allEligibleUsers.isNotEmpty
                          ? Column(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: CustomColors.mercury,
                                      border: Border.all(
                                          color: CustomColors.orchid,
                                          width: 3)),
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
                                  itemCount: allEligibleUsers.length,
                                  itemBuilder: (context, index) {
                                    Map<dynamic, dynamic> quizResults =
                                        (allEligibleUsers[index].data()! as Map<
                                            dynamic,
                                            dynamic>)['customQuizResults'];
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Container(
                                            height: 75,
                                            decoration: BoxDecoration(
                                                color: CustomColors.mercury,
                                                border: Border.all(
                                                    color: CustomColors.orchid,
                                                    width: 3)),
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
                                                          child: AutoSizeText(
                                                              '${(allEligibleUsers[index].data()! as Map<dynamic, dynamic>)['firstName']} ${(allEligibleUsers[index].data()! as Map<dynamic, dynamic>)['lastName']}',
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
                                                                  allEligibleUsers[
                                                                      index],
                                                                  'EASY')
                                                              : Center(
                                                                  child:
                                                                      _notAvailable())),
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
                                                                  allEligibleUsers[
                                                                      index],
                                                                  'AVERAGE')
                                                              : Center(
                                                                  child:
                                                                      _notAvailable())),
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
                                                                  allEligibleUsers[
                                                                      index],
                                                                  'DIFFICULT')
                                                              : Center(
                                                                  child:
                                                                      _notAvailable()))
                                                    ]))));
                                  })
                            ])
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Center(
                                  child: Text(
                                'No student has done this custom lesson yet',
                                style: wineBoldStyle(size: 30),
                              )),
                            ))
                    ],
                  ),
                ))))
      ]),
    );
  }

  TextStyle _headerStyle() {
    return const TextStyle(
        fontSize: 25, fontWeight: FontWeight.bold, color: CustomColors.orchid);
  }

  TextStyle _studentEntryStyle() {
    return const TextStyle(
        fontSize: 20, color: CustomColors.orchid, fontWeight: FontWeight.bold);
  }

  AutoSizeText _notAvailable() {
    return AutoSizeText('N/A', style: _studentEntryStyle());
  }

  Widget _quizResultEntry(DocumentSnapshot selectedDoc, String difficulty) {
    String profileImageURL =
        (selectedDoc.data()! as Map<dynamic, dynamic>)['profileImageURL'];
    String studentName =
        '${(selectedDoc.data()! as Map<dynamic, dynamic>)['firstName']} ${(selectedDoc.data()! as Map<dynamic, dynamic>)['lastName']}';
    Map<dynamic, dynamic> customQuizResults =
        (selectedDoc.data()! as Map<dynamic, dynamic>)['customQuizResults'];
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      AutoSizeText(_getQuizScoreFormatted(customQuizResults, difficulty),
          style: _studentEntryStyle()),
      ElevatedButton(
          onPressed: () => displayQuizAnswersDialogue(
              difficulty,
              context,
              allQuestions[difficulty.toLowerCase()],
              customQuizResults[widget.quizTitle][difficulty]['answers'],
              profileImageURL,
              studentName,
              customQuizResults[widget.quizTitle][difficulty]['score']),
          child: const Text('VIEW ANSWERS',
              textAlign: TextAlign.center, style: TextStyle(letterSpacing: 2)))
    ]);
  }
}
