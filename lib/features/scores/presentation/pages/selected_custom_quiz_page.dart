import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/features/scores/presentation/viewmodels/scores_viewmodel.dart';
import 'package:speechlab_dashboard/features/scores/presentation/widgets/quiz_answers_dialog.dart';

class SelectedCustomQuizPage extends HookConsumerWidget {
  final String quizTitle;
  const SelectedCustomQuizPage({super.key, required this.quizTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoresViewModelProvider);
    final viewModel = ref.read(scoresViewModelProvider.notifier);

    final allEligibleUsers = useState<List<Map<String, dynamic>>>([]);
    final allQuestions = useState<Map<String, dynamic>>({});

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getQuizResults(quizTitle);
      });
      return null;
    }, const []);

    ref.listen(scoresViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
      } else if (next is Success) {
        final data = next.data;
        if (data is Map<String, dynamic>) {
          allQuestions.value =
              Map<String, dynamic>.from(data['quizContent'] ?? {});
          allEligibleUsers.value =
              List<Map<String, dynamic>>.from(data['students'] ?? []);
        }
      }
    });

    bool hasAnsweredThisQuiz(
        Map<String, dynamic> selectedQuiz, String difficulty) {
      return selectedQuiz.containsKey(quizTitle) &&
          (selectedQuiz[quizTitle] as Map<String, dynamic>)
              .containsKey(difficulty);
    }

    String getQuizScoreFormatted(
        Map<String, dynamic> selectedQuiz, String difficulty) {
      final quizData = selectedQuiz[quizTitle] as Map<String, dynamic>;
      final difficultyScore = quizData[difficulty]['score'];
      final questionCount =
          (quizData[difficulty]['answers'] as List<dynamic>).length;
      return '$difficultyScore / $questionCount';
    }

    TextStyle studentEntryStyle() {
      return const TextStyle(
          fontSize: 20, color: CustomColors.orchid, fontWeight: FontWeight.bold);
    }

    AutoSizeText notAvailable() {
      return AutoSizeText('N/A', style: studentEntryStyle());
    }

    Widget quizResultEntry(Map<String, dynamic> studentData,
        Map<String, dynamic> customQuizResults, String difficulty) {
      String profileImageURL = studentData['profileImageURL'] ?? '';
      String studentName =
          '${studentData['firstName']} ${studentData['lastName']}';
      return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        AutoSizeText(getQuizScoreFormatted(customQuizResults, difficulty),
            style: studentEntryStyle()),
        ElevatedButton(
            onPressed: () => displayQuizAnswersDialogue(
                difficulty,
                context,
                allQuestions.value[difficulty.toLowerCase()],
                customQuizResults[quizTitle][difficulty]['answers'],
                profileImageURL,
                studentName,
                customQuizResults[quizTitle][difficulty]['score']),
            child: const Text('VIEW ANSWERS',
                textAlign: TextAlign.center,
                style: TextStyle(letterSpacing: 2)))
      ]);
    }

    Widget studentEntryHeader() {
      return Container(
          decoration: BoxDecoration(
              color: CustomColors.orchid,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CustomColors.orchid, width: 1)),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: AutoSizeText('Student #',
                            style: whiteBoldStyle(size: 25))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: AutoSizeText('Student Name',
                            style: whiteBoldStyle(size: 25))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: AutoSizeText('Easy Quiz',
                            textAlign: TextAlign.center,
                            style: whiteBoldStyle(size: 25))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: AutoSizeText('Average Quiz',
                            textAlign: TextAlign.center,
                            style: whiteBoldStyle(size: 25))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: AutoSizeText('Difficult Quiz',
                            textAlign: TextAlign.center,
                            style: whiteBoldStyle(size: 25)))
                  ])));
    }

    Widget studentEntry(Map<String, dynamic> quizResults, int index) {
      final studentData = allEligibleUsers.value[index];
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
              decoration: BoxDecoration(
                  color: CustomColors.mercury,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CustomColors.orchid, width: 1)),
              child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: AutoSizeText('${studentData['studentID']}',
                                style: studentEntryStyle())),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: AutoSizeText(
                                '${studentData['firstName']} ${studentData['lastName']}',
                                style: studentEntryStyle())),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: hasAnsweredThisQuiz(quizResults, 'EASY')
                                ? quizResultEntry(
                                    studentData, quizResults, 'EASY')
                                : Center(child: notAvailable())),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: hasAnsweredThisQuiz(quizResults, 'AVERAGE')
                                ? quizResultEntry(
                                    studentData, quizResults, 'AVERAGE')
                                : Center(child: notAvailable())),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: hasAnsweredThisQuiz(quizResults, 'DIFFICULT')
                                ? quizResultEntry(
                                    studentData, quizResults, 'DIFFICULT')
                                : Center(child: notAvailable()))
                      ]))));
    }

    Widget customQuizHeader() {
      return Row(
        children: [
          backButton(context,
              onPress: () => GoRouter.of(context).go(AppRoutes.scores)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 125,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AutoSizeText(
                      quizTitle,
                      style: wineBoldStyle(size: 40),
                    ),
                    const Divider(
                      thickness: 5,
                      color: CustomColors.orchid,
                    ),
                  ])),
        ],
      );
    }

    return DashboardShell(
      navIndex: 0,
      child: switchedLoadingContainer(
          state is Loading,
          all8Pix(SingleChildScrollView(
            child: Column(
              children: [
                customQuizHeader(),
                loveWineContainer(
                    Padding(
                      padding: const EdgeInsetsDirectional.all(20),
                      child: allEligibleUsers.value.isNotEmpty
                          ? Column(children: [
                              studentEntryHeader(),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: allEligibleUsers.value.length,
                                  itemBuilder: (context, index) {
                                    final quizResults = Map<String, dynamic>.from(
                                        allEligibleUsers.value[index]
                                                ['customQuizResults'] ??
                                            {});
                                    return studentEntry(quizResults, index);
                                  })
                            ])
                          : SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.85,
                              child: Center(
                                  child: Text(
                                'No student has done this custom lesson yet',
                                style: wineBoldStyle(size: 30),
                              )),
                            ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.80)
              ],
            ),
          ))),
    );
  }
}
