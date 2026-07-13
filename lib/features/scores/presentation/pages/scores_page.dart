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
import 'package:speechlab_dashboard/features/scores/data/models/speech_model.dart';
import 'package:speechlab_dashboard/features/scores/presentation/viewmodels/scores_viewmodel.dart';

class ScoresPage extends HookConsumerWidget {
  const ScoresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoresViewModelProvider);
    final viewModel = ref.read(scoresViewModelProvider.notifier);

    final viewingQuizScores = useState(true);
    final allCustomQuizzes = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getActiveQuizzes();
      });
      return null;
    }, const []);

    ref.listen(scoresViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
      } else if (next is Success) {
        final data = next.data;
        if (data is List<Map<String, dynamic>>) {
          allCustomQuizzes.value = data;
        }
      }
    });

    Widget scoresHeader() {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(children: [
            AutoSizeText('SCORING RESULTS', style: wineBoldStyle(size: 45)),
            const Divider(
              thickness: 5,
              color: CustomColors.orchid,
            )
          ]));
    }

    Widget scoreChoiceSelector() {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              scoreOptionButton(context,
                  label: 'Lesson Quiz Performance',
                  isSelected: viewingQuizScores.value, onPress: () {
                viewingQuizScores.value = true;
              }),
              scoreOptionButton(context,
                  label: 'SpeechLab Performance',
                  isSelected: !viewingQuizScores.value, onPress: () {
                viewingQuizScores.value = false;
              })
            ])),
      );
    }

    Widget quizzesWidget() {
      return loveWineContainer(Column(
          children: allCustomQuizzes.value
              .map((customQuiz) => vertical10PixHorizontal30Pix(context,
                  child: longEntryButton(context,
                      label: customQuiz['id'] as String, onPress: () {
                    GoRouter.of(context).goNamed(AppRoutes.selectedQuiz,
                        pathParameters: {
                          'quizTitle': customQuiz['id'] as String
                        });
                  })))
              .toList()));
    }

    Widget speechScoresWidget() {
      return loveWineContainer(
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Wrap(
              spacing: MediaQuery.of(context).size.width * 0.02,
              runSpacing: MediaQuery.of(context).size.width * 0.01,
              children: speechCategories.asMap().entries.map((entry) {
                final int index = entry.key;
                final SpeechModel level = entry.value;
                return shortEntryButton(context,
                    lessonIndex: index + 1,
                    lessonName: level.category,
                    onPress: () => GoRouter.of(context).goNamed(
                        AppRoutes.selectedSpeechLab,
                        pathParameters: {
                          'currentSpeechLevelReq': (index + 1).toString()
                        }));
              }).toList(),
            ),
          ),
        ),
      );
    }

    return DashboardShell(
      navIndex: 0,
      child: switchedLoadingContainer(
          state is Loading,
          all8Pix(SingleChildScrollView(
              child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              backButton(context,
                  onPress: () => GoRouter.of(context).go(AppRoutes.home)),
              Column(children: [
                scoresHeader(),
                scoreChoiceSelector(),
              ])
            ]),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: viewingQuizScores.value
                    ? quizzesWidget()
                    : speechScoresWidget())
          ])))),
    );
  }
}
