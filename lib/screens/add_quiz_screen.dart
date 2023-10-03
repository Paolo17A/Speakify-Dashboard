import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/widgets/choices_radio_widget.dart';
import 'package:speechlab_dashboard/widgets/speechLabTextField.dart';
import '../widgets/appbar_title_widget.dart';
import '../widgets/left_navigator_widget.dart';

class AddQuizScreen extends StatefulWidget {
  final bool isEditing;
  const AddQuizScreen({super.key, required this.isEditing});

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  bool _isLoading = false;
  String currentDifficulty = 'Easy';
  int currentQuestion = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _choicesControllers = [];
  final List<String> choiceLetters = ['a', 'b', 'c', 'd'];
  String? _correctChoice;
  bool willResetChoices = true;

  List<dynamic> easyQuestions = [];
  List<dynamic> averageQuestions = [];
  List<dynamic> difficultQuestions = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _choicesControllers.add(TextEditingController());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _questionController.dispose();
    for (var choice in _choicesControllers) {
      choice.dispose();
    }
  }

  void uploadCustomQuiz() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      setState(() {
        _isLoading = true;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error uploading custom quiz: $error')));
    }
  }

  void nextQuizBtn() {
    //  VALIDATION GUARDS
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please provide a title for this quiz.')));
      return;
    } else if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please provide a question.')));
      return;
    } else if (currentDifficulty == 'Easy') {
      for (int i = 0; i < _choicesControllers.length; i++) {
        if (_choicesControllers[i].text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please provide four choices to choose from.')));
          return;
        }
      }
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
        'answer': _correctChoice
      };
      easyQuestions.add(easyQuestionEntry);
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
          print('TIME TO UPLOAD THIS QUIZ');
        }
      }
      _questionController.clear();
      for (TextEditingController choice in _choicesControllers) {
        choice.clear();
      }
      _correctChoice = null;
      willResetChoices = true;
      print('CURRENT CHOICE: $_correctChoice');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(
          children: [
            lefNavigator(context, 0),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              color: Colors.white,
              child: Stack(children: [
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Row(children: [
                          Text('QUIZ TITLE',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold))
                        ]),
                        SpeechLabTextField(
                            text: 'Quiz Title',
                            controller: _titleController,
                            textInputType: TextInputType.text),
                        const SizedBox(height: 30),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.4),
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
                                              color: Colors.deepPurple,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  speechLabTextField('Question',
                                      _questionController, TextInputType.text),
                                  const SizedBox(height: 15),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _choicesControllers.length,
                                      itemBuilder: (context, index) {
                                        return Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child: Text(
                                              choiceLetters[index],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: speechLabTextField(
                                                'Choice',
                                                _choicesControllers[index],
                                                TextInputType.text),
                                          )
                                        ]);
                                      }),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 70, vertical: 20),
                                      child: ChoicesRadioWidget(
                                          key: GlobalKey(),
                                          willReset: willResetChoices,
                                          choiceSelectCallback:
                                              (stringVal, boolVal) {
                                            if (stringVal != null) {
                                              setState(() {
                                                _correctChoice = stringVal;
                                                willResetChoices = boolVal;
                                              });
                                            }
                                          },
                                          choiceLetters: choiceLetters)),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 75),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                              child: ElevatedButton(
                                                  onPressed: () {},
                                                  child: const Text('PREVIOUS',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                              child: ElevatedButton(
                                                  onPressed: nextQuizBtn,
                                                  child: const Text('NEXT',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                            )
                                          ]),
                                    ),
                                  )
                                ],
                              )),
                        )
                      ],
                    )),
                if (_isLoading)
                  Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator()))
              ]),
            )
          ],
        ));
  }
}
