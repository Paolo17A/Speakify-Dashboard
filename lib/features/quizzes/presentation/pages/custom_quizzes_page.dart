import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/session/auth_session_notifier.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/features/quizzes/presentation/viewmodels/quizzes_viewmodel.dart';

class CustomQuizzesPage extends HookConsumerWidget {
  const CustomQuizzesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizzesViewModelProvider);
    final viewModel = ref.read(quizzesViewModelProvider.notifier);
    final isAdmin = ref.read(authSessionProvider).isAdmin;

    final customQuizzes = useState<List<Map<String, dynamic>>>([]);
    final pendingAction = useState<String?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getAllQuizzes();
      });
      return null;
    }, const []);

    ref.listen(quizzesViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
        pendingAction.value = null;
      } else if (next is Success) {
        if (pendingAction.value == 'archive') {
          pendingAction.value = null;
          viewModel.getAllQuizzes();
          return;
        }
        final data = next.data;
        if (data is List<Map<String, dynamic>>) {
          customQuizzes.value = data;
        }
      }
    });

    void archiveQuiz(String quizTitle, bool currentValue) {
      pendingAction.value = 'archive';
      viewModel.archiveQuiz(quizTitle: quizTitle, currentValue: currentValue);
    }

    Widget customQuizzesHeader() {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(children: [
            AutoSizeText('CUSTOM QUIZZES', style: wineBoldStyle(size: 40)),
            const Divider(
              thickness: 5,
              color: CustomColors.orchid,
            )
          ]));
    }

    Widget customQuizzesContainer() {
      return customQuizzes.value.isNotEmpty
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: isAdmin
                  ? MediaQuery.of(context).size.height * 0.75
                  : MediaQuery.of(context).size.height * 0.65,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: customQuizzes.value.length,
                itemBuilder: (context, index) {
                  final quizData = customQuizzes.value[index];
                  final quizTitle = quizData['id'] as String;
                  final isArchived = quizData['isArchived'] as bool? ?? false;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                if (isAdmin) {
                                  return;
                                }
                                GoRouter.of(context).goNamed(
                                    AppRoutes.editQuiz,
                                    pathParameters: {'quizTitle': quizTitle});
                              },
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      color: CustomColors.orchid),
                                  backgroundColor: CustomColors.mercury),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: AutoSizeText(quizTitle,
                                          style: const TextStyle(
                                              color: CustomColors.orchid,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold))),
                                ],
                              )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () =>
                                  archiveQuiz(quizTitle, isArchived),
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      color: CustomColors.orchid),
                                  backgroundColor: CustomColors.mercury),
                              child: AutoSizeText(
                                  isArchived ? 'RESTORE' : 'ARCHIVE',
                                  style: const TextStyle(
                                      color: CustomColors.orchid,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold))),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          : SizedBox(
              height: isAdmin
                  ? MediaQuery.of(context).size.height * 0.75
                  : MediaQuery.of(context).size.height * 0.65,
              child: const Center(
                  child: AutoSizeText('NO CUSTOM QUIZZES AVAILABLE',
                      style: TextStyle(
                          color: CustomColors.orchid,
                          fontSize: 40,
                          fontWeight: FontWeight.bold))),
            );
    }

    return DashboardShell(
      navIndex: 0,
      child: switchedLoadingContainer(
          state is Loading,
          SingleChildScrollView(
            child: all8Pix(Column(children: [
              customQuizzesHeader(),
              loveWineContainer(Column(children: [
                if (!isAdmin)
                  addEntryButton(context,
                      label: 'ADD NEW QUIZ  ',
                      onPress: () =>
                          GoRouter.of(context).go(AppRoutes.addQuiz)),
                customQuizzesContainer()
              ]))
            ])),
          )),
    );
  }
}
