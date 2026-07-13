import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/bool_choices_radio_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/core/widgets/speechLabTextField.dart';
import 'package:speechlab_dashboard/core/widgets/string_choices_radio_widget.dart';
import 'package:speechlab_dashboard/features/quizzes/presentation/viewmodels/quizzes_viewmodel.dart';

class AddQuizPage extends HookConsumerWidget {
  const AddQuizPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizzesViewModelProvider);
    final viewModel = ref.read(quizzesViewModelProvider.notifier);

    final isLoading = useState(false);
    final pendingAction = useState<String?>(null);
    final currentDifficulty = useState('Easy');
    final currentQuestion = useState(0);

    final titleController = useTextEditingController();
    final questionController = useTextEditingController();
    final choicesControllers = useMemoized(
        () => List.generate(4, (_) => TextEditingController()), const []);
    final identificationController = useTextEditingController();
    const choiceLetters = ['a', 'b', 'c', 'd'];
    final correctChoiceString = useState<String?>(null);
    final correctChoiceBool = useState<bool?>(null);
    final stringChoice =
        useMemoized(() => GlobalKey<ChoicesRadioWidgetState>(), const []);
    final boolChoice =
        useMemoized(() => GlobalKey<BoolChoicesRadioWidgetState>(), const []);

    final easyQuestions = useState<List<dynamic>>([]);
    final averageQuestions = useState<List<dynamic>>([]);
    final difficultQuestions = useState<List<dynamic>>([]);

    useEffect(() {
      return () {
        for (final controller in choicesControllers) {
          controller.dispose();
        }
      };
    }, const []);

    ref.listen(quizzesViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
        isLoading.value = false;
        pendingAction.value = null;
      } else if (next is Success) {
        if (pendingAction.value == 'checkTitle') {
          if (next.data == true) {
            displayError(context, 'A quiz with this title already exists');
            isLoading.value = false;
            pendingAction.value = null;
            return;
          }
          pendingAction.value = 'add';
          viewModel.addQuiz(
              quizTitle: titleController.text.trim(),
              easyQuestions: easyQuestions.value,
              averageQuestions: averageQuestions.value,
              difficultQuestions: difficultQuestions.value);
        } else if (pendingAction.value == 'add') {
          pendingAction.value = null;
          GoRouter.of(context).go(AppRoutes.quizzes);
        }
      }
    });

    void uploadCustomQuiz() {
      isLoading.value = true;
      pendingAction.value = 'checkTitle';
      viewModel.quizTitleExists(titleController.text.trim());
    }

    void nextQuestion() {
      //  VALIDATION GUARDS
      if (titleController.text.isEmpty) {
        displayError(context, 'Please provide a title for this quiz.');
        return;
      } else if (questionController.text.isEmpty) {
        displayError(context, 'Please provide a question.');
        return;
      } else if (currentDifficulty.value == 'Easy') {
        if (correctChoiceString.value == null) {
          displayError(
              context, 'Please select a correct answer from the four choices.');
          return;
        }
        for (int i = 0; i < choicesControllers.length; i++) {
          if (choicesControllers[i].text.isEmpty) {
            displayError(context, 'Please provide four choices to choose from.');
            return;
          }
        }
      } else if (currentDifficulty.value == 'Average' &&
          correctChoiceBool.value == null) {
        displayError(context, 'Please select between True or False.');
        return;
      } else if (currentDifficulty.value == 'Difficult' &&
          identificationController.text.isEmpty) {
        displayError(context, 'Please input the correct answer.');
        return;
      }

      //  Create a custom map for this object
      if (currentDifficulty.value == 'Easy') {
        Map<String, dynamic> easyQuestionEntry = {
          'question': questionController.text.trim(),
          'options': {
            'a': choicesControllers[0].text.trim(),
            'b': choicesControllers[1].text.trim(),
            'c': choicesControllers[2].text.trim(),
            'd': choicesControllers[3].text.trim()
          },
          'answer': correctChoiceString.value
        };
        if (currentQuestion.value == easyQuestions.value.length) {
          easyQuestions.value.add(easyQuestionEntry);
        } else {
          easyQuestions.value[currentQuestion.value] = easyQuestionEntry;
        }
      } else if (currentDifficulty.value == 'Average') {
        Map<String, dynamic> averageQuestionEntry = {
          'question': questionController.text.trim(),
          'answer': correctChoiceBool.value
        };
        if (currentQuestion.value == averageQuestions.value.length) {
          averageQuestions.value.add(averageQuestionEntry);
        } else {
          averageQuestions.value[currentQuestion.value] = averageQuestionEntry;
        }
      } else if (currentDifficulty.value == 'Difficult') {
        Map<String, dynamic> difficultQuestionEntry = {
          'question': questionController.text.trim(),
          'answer': [identificationController.text.trim()]
        };
        if (currentQuestion.value == difficultQuestions.value.length) {
          difficultQuestions.value.add(difficultQuestionEntry);
        } else {
          difficultQuestions.value[currentQuestion.value] =
              difficultQuestionEntry;
        }
      }

      currentQuestion.value++;
      if (currentQuestion.value == 10) {
        currentQuestion.value = 0;
        if (currentDifficulty.value == 'Easy') {
          currentDifficulty.value = 'Average';
        } else if (currentDifficulty.value == 'Average') {
          currentDifficulty.value = 'Difficult';
        } else if (currentDifficulty.value == 'Difficult') {
          uploadCustomQuiz();
          return;
        }
      }
      if (currentDifficulty.value == 'Easy' &&
          currentQuestion.value <= easyQuestions.value.length - 1) {
        Map<dynamic, dynamic> selectedQuestion =
            easyQuestions.value[currentQuestion.value];
        questionController.text = selectedQuestion['question'];
        for (int i = 0; i < choicesControllers.length; i++) {
          choicesControllers[i].text =
              selectedQuestion['options'][choiceLetters[i]];
        }
        correctChoiceString.value = selectedQuestion['answer'];
        stringChoice.currentState?.setChoice(correctChoiceString.value!);
      } else if (currentDifficulty.value == 'Average' &&
          currentQuestion.value <= averageQuestions.value.length - 1) {
        Map<dynamic, dynamic> selectedQuestion =
            averageQuestions.value[currentQuestion.value];
        questionController.text = selectedQuestion['question'];
        correctChoiceBool.value = selectedQuestion['answer'];
        boolChoice.currentState?.setChoice(correctChoiceBool.value!);
      } else if (currentDifficulty.value == 'Difficult' &&
          currentQuestion.value <= difficultQuestions.value.length - 1) {
        Map<dynamic, dynamic> selectedQuestion =
            difficultQuestions.value[currentQuestion.value];
        questionController.text = selectedQuestion['question'];
        identificationController.text = selectedQuestion['answer'][0];
      } else {
        questionController.clear();
        if (currentDifficulty.value == 'Easy') {
          for (TextEditingController choice in choicesControllers) {
            choice.clear();
          }
          correctChoiceString.value = null;
          stringChoice.currentState?.resetChoice();
        } else if (currentDifficulty.value == 'Average') {
          correctChoiceBool.value = null;
          boolChoice.currentState?.resetChoice();
        } else if (currentDifficulty.value == 'Difficult') {
          identificationController.clear();
        }
      }
    }

    void previousQuestion() {
      if (currentQuestion.value == 0 && currentDifficulty.value == 'Easy') {
        return;
      }

      currentQuestion.value--;
      if (currentQuestion.value == -1) {
        if (currentDifficulty.value == 'Average') {
          currentDifficulty.value = 'Easy';
        } else if (currentDifficulty.value == 'Difficult') {
          currentDifficulty.value = 'Average';
        }
        currentQuestion.value = 9;
      }

      if (currentDifficulty.value == 'Easy') {
        questionController.text =
            easyQuestions.value[currentQuestion.value]['question'];
        choicesControllers[0].text =
            easyQuestions.value[currentQuestion.value]['options']['a'];
        choicesControllers[1].text =
            easyQuestions.value[currentQuestion.value]['options']['b'];
        choicesControllers[2].text =
            easyQuestions.value[currentQuestion.value]['options']['c'];
        choicesControllers[3].text =
            easyQuestions.value[currentQuestion.value]['options']['d'];
        correctChoiceString.value =
            easyQuestions.value[currentQuestion.value]['answer'];
        stringChoice.currentState?.setChoice(correctChoiceString.value!);
      } else if (currentDifficulty.value == 'Average') {
        questionController.text =
            averageQuestions.value[currentQuestion.value]['question'];
        correctChoiceBool.value =
            averageQuestions.value[currentQuestion.value]['answer'];
        boolChoice.currentState?.setChoice(correctChoiceBool.value!);
      } else if (currentDifficulty.value == 'Difficult') {
        questionController.text =
            difficultQuestions.value[currentQuestion.value]['question'];
        identificationController.text =
            difficultQuestions.value[currentQuestion.value]['answer'][0];
      }
    }

    Widget quizTitle() {
      return Row(
        children: [
          backButton(context,
              onPress: () => GoRouter.of(context).go(AppRoutes.quizzes)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(children: [
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('QUIZ TITLE',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
              ]),
              speechLabTextField(
                  'Quiz Title', titleController, TextInputType.text, null),
              const SizedBox(height: 30)
            ]),
          ),
        ],
      );
    }

    Widget easyQuestionInput() {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: choicesControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: Text(
                        choiceLetters[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: CustomColors.orchid,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: speechLabTextField('Choice',
                          choicesControllers[index], TextInputType.text, null),
                    )
                  ]),
                );
              }),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
              child: StringChoicesRadioWidget(
                  key: stringChoice,
                  initialString: correctChoiceString.value,
                  choiceSelectCallback: (stringVal) {
                    if (stringVal != null) {
                      correctChoiceString.value = stringVal;
                    }
                  },
                  choiceLetters: choiceLetters)),
        ],
      );
    }

    Widget averageQuestionInput() {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
          child: BoolChoicesRadioWidget(
              key: boolChoice,
              initialBool: correctChoiceBool.value,
              choiceSelectCallback: (boolVal) {
                if (boolVal != null) {
                  correctChoiceBool.value = boolVal;
                }
              }));
    }

    Widget difficultQuestionInput() {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: speechLabTextField('Correct Answer', identificationController,
            TextInputType.text, null),
      );
    }

    Widget quizInputContainer() {
      return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
            color: CustomColors.love,
            border: Border.all(color: CustomColors.orchid, width: 3),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                        '${currentDifficulty.value} Question #${currentQuestion.value + 1}',
                        style: const TextStyle(
                            color: CustomColors.orchid,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5),
                speechLabTextField(
                    'Question', questionController, TextInputType.text, null),
                const SizedBox(height: 15),
                if (currentDifficulty.value == 'Easy') easyQuestionInput(),
                if (currentDifficulty.value == 'Average') averageQuestionInput(),
                if (currentDifficulty.value == 'Difficult')
                  difficultQuestionInput(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.height * 0.1,
                                child: ElevatedButton(
                                    onPressed: previousQuestion,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: CustomColors.orchid),
                                    child: const Text('PREVIOUS',
                                        style: TextStyle(color: Colors.white))),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.height * 0.1,
                                child: ElevatedButton(
                                    onPressed: nextQuestion,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: CustomColors.orchid),
                                    child: Text(
                                        (currentDifficulty.value ==
                                                    'Difficult' &&
                                                currentQuestion.value == 9)
                                            ? 'SUBMIT'
                                            : 'NEXT',
                                        style: const TextStyle(
                                            color: Colors.white))),
                              )
                            ]),
                      ],
                    ),
                  ),
                )
              ],
            )),
      );
    }

    return DashboardShell(
      navIndex: 0,
      child: stackedLoadingContainer(
          context, isLoading.value || state is Loading, [
        SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [quizTitle(), quizInputContainer()],
              )),
        ),
      ]),
    );
  }
}
