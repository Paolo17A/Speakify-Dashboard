import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';

import '../utils/color_util.dart';
import '../widgets/appbar_title_widget.dart';
import '../widgets/bool_choices_radio_widget.dart';
import '../widgets/left_navigator_widget.dart';
import '../widgets/speechLabTextField.dart';
import '../widgets/string_choices_radio_widget.dart';

class EditQuizScreen extends StatefulWidget {
  final String quizTitle;
  final String serializedQuizContent;
  const EditQuizScreen(
      {super.key,
      required this.quizTitle,
      required this.serializedQuizContent});

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  bool _isLoading = false;
  String currentDifficulty = 'Easy';
  int currentQuestion = 0;

  String quizTitle = '';
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _choicesControllers = [];
  final TextEditingController _identificationController =
      TextEditingController();
  final List<String> choiceLetters = ['a', 'b', 'c', 'd'];
  String? _correctChoiceString;
  bool? _correctChoiceBool;
  final GlobalKey<ChoicesRadioWidgetState> stringChoice = GlobalKey();
  final GlobalKey<BoolChoicesRadioWidgetState> boolChoice = GlobalKey();

  List<dynamic> easyQuestions = [];
  List<dynamic> averageQuestions = [];
  List<dynamic> difficultQuestions = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _choicesControllers.add(TextEditingController());
    }
    Map<String, dynamic> quizContent = jsonDecode(widget.serializedQuizContent);
    easyQuestions = quizContent['easy'];
    averageQuestions = quizContent['average'];
    difficultQuestions = quizContent['difficult'];
    _questionController.text = easyQuestions[currentQuestion]['question'];
    for (int i = 0; i < _choicesControllers.length; i++) {
      _choicesControllers[i].text =
          easyQuestions[currentQuestion]['options'][choiceLetters[i]];
    }

    _correctChoiceString = easyQuestions[currentQuestion]['answer'];
    stringChoice.currentState?.setChoice(_correctChoiceString!);
  }

  @override
  void dispose() {
    super.dispose();
    _questionController.dispose();
    for (var choice in _choicesControllers) {
      choice.dispose();
    }
    _identificationController.dispose();
  }

  void uploadCustomQuiz() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    try {
      setState(() {
        _isLoading = true;
      });

      Map<dynamic, dynamic> quizContent = {
        'easy': easyQuestions,
        'average': averageQuestions,
        'difficult': difficultQuestions
      };
      String encodedQuiz = jsonEncode(quizContent);
      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.quizTitle)
          .set({
        'quizContent': encodedQuiz,
        'isArchived': false,
        'dateAdded': DateTime.now()
      });

      final instructor = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<dynamic, dynamic> instructorData =
          instructor.data() as Map<dynamic, dynamic>;

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${instructorData['firstName']} ${instructorData['lastName']} edited a quiz: ${widget.quizTitle}.'
      });

      setState(() {
        _isLoading = false;
      });

      goRouter.go('/quizzes');
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error uploading custom quiz: $error')));
    }
  }

  void nextQuestion() {
    //  VALIDATION GUARDS
    if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please provide a question.')));
      return;
    } else if (currentDifficulty == 'Easy') {
      if (_correctChoiceString == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Please select a correct answer from the four choices.')));
        return;
      }
      for (int i = 0; i < _choicesControllers.length; i++) {
        if (_choicesControllers[i].text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please provide four choices to choose from.')));
          return;
        }
      }
    } else if (currentDifficulty == 'Average' && _correctChoiceBool == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select between True or False.')));
      return;
    } else if (currentDifficulty == 'Difficult' &&
        _identificationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please input the correct answer.')));
      return;
    }

    //  Create a custom map for this object
    if (currentDifficulty == 'Easy') {
      Map<String, dynamic> easyQuestionEntry = {
        'question': _questionController.text.trim(),
        'options': {
          'a': _choicesControllers[0].text.trim(),
          'b': _choicesControllers[1].text.trim(),
          'c': _choicesControllers[2].text.trim(),
          'd': _choicesControllers[3].text.trim()
        },
        'answer': _correctChoiceString
      };
      easyQuestions[currentQuestion] = easyQuestionEntry;
    } else if (currentDifficulty == 'Average') {
      Map<String, dynamic> averageQuestionEntry = {
        'question': _questionController.text.trim(),
        'answer': _correctChoiceBool
      };
      averageQuestions[currentQuestion] = averageQuestionEntry;
    } else if (currentDifficulty == 'Difficult') {
      Map<String, dynamic> difficultQuestionEntry = {
        'question': _questionController.text.trim(),
        'answer': [_identificationController.text.trim()]
      };
      difficultQuestions[currentQuestion] = difficultQuestionEntry;
    }
    setState(() {
      currentQuestion++;
      if (currentQuestion == 10) {
        currentQuestion = 0;
        if (currentDifficulty == 'Easy') {
          currentDifficulty = 'Average';
        } else if (currentDifficulty == 'Average') {
          currentDifficulty = 'Difficult';
        } else if (currentDifficulty == 'Difficult') {
          uploadCustomQuiz();
          return;
        }
      }
      if (currentDifficulty == 'Easy' &&
          currentQuestion <= easyQuestions.length - 1) {
        Map<dynamic, dynamic> selectedQuestion = easyQuestions[currentQuestion];
        for (int i = 0; i < _choicesControllers.length; i++) {
          _choicesControllers[i].text =
              easyQuestions[currentQuestion]['options'][choiceLetters[i]];
        }
        _correctChoiceString = selectedQuestion['answer'];
        stringChoice.currentState?.setChoice(_correctChoiceString!);
      } else if (currentDifficulty == 'Average' &&
          currentQuestion <= averageQuestions.length - 1) {
        Map<dynamic, dynamic> selectedQuestion =
            averageQuestions[currentQuestion];
        _questionController.text = selectedQuestion['question'];
        _correctChoiceBool = selectedQuestion['answer'];
        boolChoice.currentState?.setChoice(_correctChoiceBool!);
      } else if (currentDifficulty == 'Difficult' &&
          currentQuestion <= difficultQuestions.length - 1) {
        Map<dynamic, dynamic> selectedQuestion =
            difficultQuestions[currentQuestion];
        _questionController.text = selectedQuestion['question'];
        _identificationController.text = selectedQuestion['answer'][0];
      }
    });
  }

  void previousQuestion() {
    if (currentQuestion == 0 && currentDifficulty == 'Easy') {
      return;
    }

    setState(() {
      currentQuestion--;
      if (currentQuestion == -1) {
        if (currentDifficulty == 'Average') {
          currentDifficulty = 'Easy';
        } else if (currentDifficulty == 'Difficult') {
          currentDifficulty = 'Average';
        }
        currentQuestion = 9;
      }

      if (currentDifficulty == 'Easy') {
        _questionController.text = easyQuestions[currentQuestion]['question'];
        for (int i = 0; i < _choicesControllers.length; i++) {
          _choicesControllers[i].text =
              easyQuestions[currentQuestion]['options'][choiceLetters[i]];
        }
        _correctChoiceString = easyQuestions[currentQuestion]['answer'];
        stringChoice.currentState?.setChoice(_correctChoiceString!);
      } else if (currentDifficulty == 'Average') {
        _questionController.text =
            averageQuestions[currentQuestion]['question'];
        _correctChoiceBool = averageQuestions[currentQuestion]['answer'];
        boolChoice.currentState?.setChoice(_correctChoiceBool!);
      } else if (currentDifficulty == 'Difficult') {
        _questionController.text =
            difficultQuestions[currentQuestion]['question'];
        _identificationController.text =
            difficultQuestions[currentQuestion]['answer'][0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(
          children: [
            lefNavigator(context, 0, isAdmin: false),
            bodyWidgetWhiteBG(
                context,
                stackedLoadingContainer(context, _isLoading, [
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(children: [
                            Text(widget.quizTitle,
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold))
                          ]),
                          const SizedBox(height: 30),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.7,
                            decoration: BoxDecoration(
                                color: CustomColors.love,
                                border: Border.all(
                                    color: CustomColors.wine, width: 3),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                                padding: const EdgeInsets.all(26),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            '$currentDifficulty Question #${currentQuestion + 1}',
                                            style: const TextStyle(
                                                color: CustomColors.orchid,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    speechLabTextField(
                                        'Question',
                                        _questionController,
                                        TextInputType.text,
                                        null),
                                    const SizedBox(height: 15),
                                    if (currentDifficulty == 'Easy')
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _choicesControllers.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3),
                                              child: Row(children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  child: Text(
                                                    choiceLetters[index],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color:
                                                            CustomColors.orchid,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: speechLabTextField(
                                                      'Choice',
                                                      _choicesControllers[
                                                          index],
                                                      TextInputType.text,
                                                      null),
                                                )
                                              ]),
                                            );
                                          }),
                                    if (currentDifficulty == 'Easy')
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 70, vertical: 20),
                                          child: StringChoicesRadioWidget(
                                              key: stringChoice,
                                              initialString:
                                                  _correctChoiceString,
                                              choiceSelectCallback:
                                                  (stringVal) {
                                                if (stringVal != null) {
                                                  setState(() {
                                                    _correctChoiceString =
                                                        stringVal;
                                                  });
                                                }
                                              },
                                              choiceLetters: choiceLetters)),
                                    if (currentDifficulty == 'Average')
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 70, vertical: 20),
                                          child: BoolChoicesRadioWidget(
                                              key: boolChoice,
                                              initialBool: _correctChoiceBool,
                                              choiceSelectCallback: (boolVal) {
                                                if (boolVal != null) {
                                                  setState(() {
                                                    _correctChoiceBool =
                                                        boolVal;
                                                  });
                                                }
                                              })),
                                    if (currentDifficulty == 'Difficult')
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: speechLabTextField(
                                            'Correct Answer',
                                            _identificationController,
                                            TextInputType.text,
                                            null),
                                      ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 75),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    child: ElevatedButton(
                                                        onPressed:
                                                            previousQuestion,
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    CustomColors
                                                                        .orchid),
                                                        child: const Text(
                                                            'PREVIOUS',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    child: ElevatedButton(
                                                        onPressed: nextQuestion,
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    CustomColors
                                                                        .orchid),
                                                        child: Text(
                                                            (currentDifficulty ==
                                                                        'Difficult' &&
                                                                    currentQuestion ==
                                                                        9)
                                                                ? 'SUBMIT'
                                                                : 'NEXT',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                  )
                                                ]),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ))
                ]))
          ],
        ));
  }
}
