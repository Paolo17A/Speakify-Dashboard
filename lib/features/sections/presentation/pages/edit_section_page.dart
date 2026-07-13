import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/color_util.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/dropdown_widget.dart';
import 'package:speechlab_dashboard/features/sections/presentation/viewmodels/sections_viewmodel.dart';

class EditSectionPage extends HookConsumerWidget {
  final String sectionName;
  const EditSectionPage({super.key, required this.sectionName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sectionsViewModelProvider);
    final viewModel = ref.read(sectionsViewModelProvider.notifier);

    final isLoading = useState(true);
    final pendingAction = useState<String?>(null);
    final accessedLessonsMap = useState<Map<String, String>>({});
    final allSelectableLessons = useState<Map<String, String>>({});
    final allLessonsAccessed = useState(false);
    final currentSelectedLesson = useState('');

    final accessedQuizzes = useState<List<dynamic>>([]);
    final allSelectableQuizzes = useState<List<dynamic>>([]);
    final allQuizzesAccessed = useState(false);
    final currentSelectedQuiz = useState('');

    void loadSectionDetails() {
      isLoading.value = true;
      viewModel.getSectionDetails(sectionName);
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadSectionDetails();
      });
      return null;
    }, const []);

    ref.listen(sectionsViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
        isLoading.value = false;
        pendingAction.value = null;
      } else if (next is Success) {
        final action = pendingAction.value;
        if (action != null) {
          pendingAction.value = null;
          if (action == 'grantLesson') {
            displayError(context, 'Successfully added new lesson to section.');
          } else if (action == 'removeLesson') {
            displayError(context,
                'Successfully removed access to this lesson for this section.');
          } else if (action == 'grantQuiz') {
            displayError(context, 'Successfully added new quiz to section.');
          } else if (action == 'removeQuiz') {
            displayError(context,
                'Successfully removed access to this quiz for this section.');
          }
          loadSectionDetails();
          return;
        }
        final data = next.data;
        if (data is Map<String, dynamic>) {
          accessedLessonsMap.value =
              Map<String, String>.from(data['accessedLessonsMap'] ?? {});
          allSelectableLessons.value =
              Map<String, String>.from(data['allSelectableLessons'] ?? {});
          allLessonsAccessed.value = data['allLessonsAccessed'] ?? false;
          accessedQuizzes.value =
              List<dynamic>.from(data['accessedQuizzes'] ?? []);
          allSelectableQuizzes.value =
              List<dynamic>.from(data['allSelectableQuizzes'] ?? []);
          allQuizzesAccessed.value = data['allQuizzesAccessed'] ?? false;
          isLoading.value = false;
        }
      }
    });

    void grantAccessToLesson() {
      if (currentSelectedLesson.value.isEmpty) return;
      GoRouter.of(context).pop();
      isLoading.value = true;
      pendingAction.value = 'grantLesson';
      viewModel.grantLessonAccess(
          sectionName: sectionName, lessonID: currentSelectedLesson.value);
    }

    void removeAccessToLesson() {
      if (currentSelectedLesson.value.isEmpty) return;
      GoRouter.of(context).pop();
      isLoading.value = true;
      pendingAction.value = 'removeLesson';
      viewModel.removeLessonAccess(
          sectionName: sectionName, lessonID: currentSelectedLesson.value);
    }

    void grantAccessToQuiz() {
      if (currentSelectedQuiz.value.isEmpty) return;
      GoRouter.of(context).pop();
      isLoading.value = true;
      pendingAction.value = 'grantQuiz';
      viewModel.grantQuizAccess(
          sectionName: sectionName, quizID: currentSelectedQuiz.value);
    }

    void removeAccessToQuiz() {
      if (currentSelectedQuiz.value.isEmpty) return;
      GoRouter.of(context).pop();
      isLoading.value = true;
      pendingAction.value = 'removeQuiz';
      viewModel.removeQuizAccess(
          sectionName: sectionName, quizID: currentSelectedQuiz.value);
    }

    void showAddLessonDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (context, setDialogState) => AlertDialog(
                      backgroundColor: CustomColors.love,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomColors.orchid, width: 3)),
                        child: all20Pix(Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'SELECT A LESSON TO GRANT ACCESS',
                              style: wineBoldStyle(size: 35),
                            ),
                            dropdownWidget(currentSelectedLesson.value,
                                (selected) {
                              setDialogState(() {
                                currentSelectedLesson.value =
                                    allSelectableLessons.value.keys
                                        .firstWhere((key) =>
                                            allSelectableLessons
                                                .value[key] ==
                                            selected!);
                              });
                            }, allSelectableLessons.value.values.toList(),
                                currentSelectedLesson.value, false),
                            ElevatedButton(
                                onPressed: () => grantAccessToLesson(),
                                child: all20Pix(
                                    const Text('GRANT ACCESS TO THIS LESSON'))),
                            const Gap(50),
                            ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('\tCLOSE\t')),
                          ],
                        )),
                      ),
                    ));
          });
    }

    void showRemoveLessonDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (context, setDialogState) => AlertDialog(
                      backgroundColor: CustomColors.love,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomColors.orchid, width: 3)),
                        child: all20Pix(Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'SELECT A LESSON TO REMOVE',
                              style: wineBoldStyle(size: 35),
                            ),
                            dropdownWidget(currentSelectedLesson.value,
                                (selected) {
                              setDialogState(() {
                                currentSelectedLesson.value =
                                    accessedLessonsMap.value.keys.firstWhere(
                                        (key) =>
                                            accessedLessonsMap.value[key] ==
                                            selected!);
                              });
                            }, accessedLessonsMap.value.values.toList(),
                                currentSelectedLesson.value, false),
                            ElevatedButton(
                                onPressed: () => removeAccessToLesson(),
                                child:
                                    all20Pix(const Text('REMOVE THIS LESSON'))),
                            const Gap(50),
                            ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('\tCLOSE\t')),
                          ],
                        )),
                      ),
                    ));
          });
    }

    void showAddQuizDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (context, setDialogState) => AlertDialog(
                      backgroundColor: CustomColors.love,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomColors.orchid, width: 3)),
                        child: all20Pix(Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'SELECT A QUIZ TO GRANT ACCESS',
                              style: wineBoldStyle(size: 35),
                            ),
                            dropdownWidget(currentSelectedQuiz.value,
                                (selected) {
                              setDialogState(() {
                                currentSelectedQuiz.value = selected!;
                              });
                            }, List<String>.from(allSelectableQuizzes.value),
                                currentSelectedQuiz.value, false),
                            ElevatedButton(
                                onPressed: () => grantAccessToQuiz(),
                                child: all20Pix(
                                    const Text('GRANT ACCESS TO THIS QUIZ'))),
                            const Gap(50),
                            ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('\tCLOSE\t')),
                          ],
                        )),
                      ),
                    ));
          });
    }

    void showRemoveQuizDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (context, setDialogState) => AlertDialog(
                      backgroundColor: CustomColors.love,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomColors.orchid, width: 3)),
                        child: all20Pix(Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'SELECT A QUIZ TO REMOVE',
                              style: wineBoldStyle(size: 35),
                            ),
                            dropdownWidget(currentSelectedQuiz.value,
                                (selected) {
                              setDialogState(() {
                                currentSelectedQuiz.value = selected!;
                              });
                            }, List<String>.from(accessedQuizzes.value),
                                currentSelectedQuiz.value, false),
                            ElevatedButton(
                                onPressed: () => removeAccessToQuiz(),
                                child:
                                    all20Pix(const Text('REMOVE THIS LESSON'))),
                            const Gap(50),
                            ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('\tCLOSE\t')),
                          ],
                        )),
                      ),
                    ));
          });
    }

    Widget selectedSectionHeader() {
      return all8Pix(
        Row(
          children: [
            backButton(context,
                onPress: () =>
                    GoRouter.of(context).go(AppRoutes.instructorsEdit)),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(children: [
                  AutoSizeText(sectionName, style: wineBoldStyle(size: 40)),
                  const Divider(
                    thickness: 5,
                    color: CustomColors.orchid,
                  )
                ])),
          ],
        ),
      );
    }

    Widget lessonsContainer() {
      return all8Pix(loveWineContainer(
          all20Pix(Column(
            children: [
              Text('ACCESSED LESSONS', style: wineBoldStyle(size: 35)),
              all20Pix(
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!allLessonsAccessed.value)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                currentSelectedLesson.value = '';
                                showAddLessonDialog();
                              },
                              child:
                                  Text('Add Lesson', style: whiteBoldStyle())),
                        ),
                      if (accessedLessonsMap.value.isNotEmpty)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                currentSelectedLesson.value = '';
                                showRemoveLessonDialog();
                              },
                              child: Text('Remove Lesson',
                                  style: whiteBoldStyle())),
                        )
                    ]),
              ),
              accessedLessonsMap.value.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: accessedLessonsMap.value.length,
                      itemBuilder: (context, index) {
                        List<String> lessonIDs =
                            accessedLessonsMap.value.keys.toList();
                        final lessonName =
                            accessedLessonsMap.value[lessonIDs[index]];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: loveWineContainer(
                              all8Pix(Center(child: Text(lessonName!)))),
                        );
                      })
                  : Expanded(
                      child: Text(
                      'This section has no accessed lessons yet.',
                      style: wineBoldStyle(),
                    ))
            ],
          )),
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.75));
    }

    Widget quizzesContainer() {
      return all8Pix(loveWineContainer(
          all20Pix(Column(
            children: [
              Text('ACCESSED QUIZZES', style: wineBoldStyle(size: 35)),
              all20Pix(
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!allQuizzesAccessed.value)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                currentSelectedQuiz.value = '';
                                showAddQuizDialog();
                              },
                              child:
                                  Text('Add Quiz', style: whiteBoldStyle())),
                        ),
                      if (accessedQuizzes.value.isNotEmpty)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                currentSelectedQuiz.value = '';
                                showRemoveQuizDialog();
                              },
                              child: Text('Remove Quiz',
                                  style: whiteBoldStyle())),
                        )
                    ]),
              ),
              accessedQuizzes.value.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: accessedQuizzes.value.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: loveWineContainer(all8Pix(Center(
                              child:
                                  Text(accessedQuizzes.value[index])))),
                        );
                      })
                  : Expanded(
                      child: Text(
                      'This section has no accessed lessons yet.',
                      style: wineBoldStyle(),
                    ))
            ],
          )),
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.75));
    }

    return DashboardShell(
      navIndex: 2,
      child: stackedLoadingContainer(
          context, isLoading.value || state is Loading, [
        SingleChildScrollView(
          child: Column(
            children: [
              selectedSectionHeader(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [lessonsContainer(), quizzesContainer()],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
