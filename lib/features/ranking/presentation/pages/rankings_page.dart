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
import 'package:speechlab_dashboard/features/ranking/presentation/viewmodels/ranking_viewmodel.dart';
import 'package:speechlab_dashboard/features/scores/data/models/speech_model.dart';

class RankingsPage extends HookConsumerWidget {
  const RankingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rankingViewModelProvider);
    final viewModel = ref.read(rankingViewModelProvider.notifier);

    final viewingQuizScores = useState(true);
    final currentSectionIndex = useState(0);
    final allSections = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getSectionsAndQuizzes();
      });
      return null;
    }, const []);

    ref.listen(rankingViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
      } else if (next is Success) {
        final data = next.data;
        if (data is List<Map<String, dynamic>>) {
          allSections.value = data;
          currentSectionIndex.value = 0;
        }
      }
    });

    final accessedCustomQuizzes = allSections.value.isNotEmpty
        ? List<String>.from(
            allSections.value[currentSectionIndex.value]['accessedQuizzes'] ??
                [])
        : <String>[];

    Widget scoreChoiceSelector() {
      return all20Pix(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        scoreOptionButton(context,
            label: 'Lesson Quiz Leaderboard',
            isSelected: viewingQuizScores.value, onPress: () {
          viewingQuizScores.value = true;
        }),
        scoreOptionButton(context,
            label: 'SpeechLab Leaderboard',
            isSelected: !viewingQuizScores.value, onPress: () {
          viewingQuizScores.value = false;
        })
      ]));
    }

    Widget broadcastingSectionHeader() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(context,
              onPress: () => GoRouter.of(context).go(AppRoutes.home)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(children: [
                AutoSizeText('Leaderboard', style: wineBoldStyle(size: 40)),
                const Divider(
                  thickness: 5,
                  color: CustomColors.orchid,
                ),
                scoreChoiceSelector()
              ])),
        ],
      );
    }

    Widget sectionSelectionRow() {
      return all8Pix(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 40,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: allSections.value.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        height: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              if (currentSectionIndex.value == index) {
                                return;
                              }
                              currentSectionIndex.value = index;
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    index == currentSectionIndex.value
                                        ? Colors.white
                                        : CustomColors.orchid),
                            child: Text(
                                allSections.value[index]['sectionName']
                                    as String,
                                style: index == currentSectionIndex.value
                                    ? blackBoldStyle()
                                    : whiteBoldStyle())),
                      ),
                    );
                  }),
            )
          ],
        ),
      );
    }

    Widget quizzesWidget() {
      return Column(
          children: accessedCustomQuizzes
              .map((quizID) => vertical10PixHorizontal30Pix(context,
                  child: longEntryButton(context, label: quizID, onPress: () {
                    GoRouter.of(context)
                        .goNamed(AppRoutes.quizRanking, pathParameters: {
                      'quizID': quizID
                    });
                  })))
              .toList());
    }

    Widget speechScoresWidget() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: MediaQuery.of(context).size.width * 0.02,
          runSpacing: MediaQuery.of(context).size.width * 0.01,
          children: speechCategories.asMap().entries.map((entry) {
            final int index = entry.key;
            final SpeechModel level = entry.value;
            return shortEntryButton(context,
                lessonIndex: index + 1, lessonName: level.category, onPress: () {
              GoRouter.of(context).goNamed(AppRoutes.speechRanking,
                  pathParameters: {
                    'currentSpeechLevelReq': (index + 1).toString()
                  });
            });
          }).toList(),
        ),
      );
    }

    return DashboardShell(
      navIndex: 0,
      child: switchedLoadingContainer(
          state is Loading,
          vertical10PixHorizontal30Pix(context,
              child: SingleChildScrollView(
                child: Column(children: [
                  broadcastingSectionHeader(),
                  loveWineContainer(
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            sectionSelectionRow(),
                            viewingQuizScores.value
                                ? quizzesWidget()
                                : speechScoresWidget()
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.8)
                ]),
              ))),
    );
  }
}
