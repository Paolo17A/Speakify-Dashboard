import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/utils/number_util.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/features/scores/data/models/speech_model.dart';
import 'package:speechlab_dashboard/features/scores/presentation/viewmodels/scores_viewmodel.dart';
import 'package:speechlab_dashboard/features/scores/presentation/widgets/speech_results_dialog.dart';

class SelectedSpeechLabPage extends HookConsumerWidget {
  final String currentSpeechLevelReq;
  const SelectedSpeechLabPage({super.key, required this.currentSpeechLevelReq});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoresViewModelProvider);
    final viewModel = ref.read(scoresViewModelProvider.notifier);

    final currentSpeechLevel = useMemoized(
        () => int.parse(currentSpeechLevelReq), [currentSpeechLevelReq]);
    final selectedLevel = useMemoized(
        () => getSpeeechByIndex(currentSpeechLevel)!, [currentSpeechLevel]);

    final students = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getSpeechLabResults(currentSpeechLevel);
      });
      return null;
    }, const []);

    ref.listen(scoresViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
      } else if (next is Success) {
        final data = next.data;
        if (data is List<Map<String, dynamic>>) {
          students.value = data;
        }
      }
    });

    Widget selectedSpeechLabHeader() {
      return Row(
        children: [
          backButton(context,
              onPress: () => GoRouter.of(context).go(AppRoutes.scores)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(children: [
                AutoSizeText(selectedLevel.category,
                    style: wineBoldStyle(size: 40)),
                const Divider(
                  thickness: 5,
                  color: CustomColors.orchid,
                )
              ])),
        ],
      );
    }

    Widget labelHeaderRow() {
      return Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CustomColors.orchid,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: const AutoSizeText('ID Number',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mercury,
                        fontSize: 26))),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: const AutoSizeText('Student Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mercury,
                        fontSize: 26))),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: const Center(
                  child: AutoSizeText('Average Score',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.mercury,
                          fontSize: 26)),
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            )
          ]));
    }

    Widget speechLabEntriesContainer() {
      return students.value.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: students.value.length,
              itemBuilder: (context, index) {
                final userData = students.value[index];
                final speechResults =
                    Map<String, dynamic>.from(userData['speechResults'] ?? {});
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                        height: 85,
                        decoration: BoxDecoration(
                            color: CustomColors.mercury,
                            border:
                                Border.all(color: CustomColors.orchid, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width * 0.2,
                                      child: AutoSizeText(
                                          '${userData['studentID']}',
                                          style: wineBoldStyle(size: 20))),
                                  SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width * 0.2,
                                      child: AutoSizeText(
                                          '${userData['firstName']} ${userData['lastName']}',
                                          style: wineBoldStyle(size: 20))),
                                  SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width * 0.2,
                                      child: Center(
                                        child: AutoSizeText(
                                            '${calculateAverage(speechResults[currentSpeechLevelReq]['confidenceScores']).toStringAsFixed(2)}%',
                                            style: wineBoldStyle(size: 20)),
                                      )),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.05,
                                    child: ElevatedButton(
                                      onPressed: () => displaySpeechResultsDialogue(
                                          context,
                                          sentences: speechCategories[
                                                  currentSpeechLevel - 1]
                                              .sentences,
                                          sentenceResults: speechResults[
                                                  currentSpeechLevelReq]
                                              ['confidenceScores'],
                                          profileImageURL:
                                              userData['profileImageURL'] ?? '',
                                          studentName:
                                              '${userData['firstName']} ${userData['lastName']}'),
                                      child: const Icon(Icons.remove_red_eye),
                                    ),
                                  )
                                ]))));
              })
          : Expanded(
              child: Center(
                  child: Text('No student has done this lesson yet',
                      style: wineBoldStyle(size: 25))));
    }

    return DashboardShell(
      navIndex: 0,
      child: switchedLoadingContainer(
          state is Loading,
          SingleChildScrollView(
            child: all8Pix(Column(
              children: [
                selectedSpeechLabHeader(),
                loveWineContainer(
                  height: MediaQuery.of(context).size.height * 0.85,
                  all20Pix(Column(
                    children: [labelHeaderRow(), speechLabEntriesContainer()],
                  )),
                ),
              ],
            )),
          )),
    );
  }
}
