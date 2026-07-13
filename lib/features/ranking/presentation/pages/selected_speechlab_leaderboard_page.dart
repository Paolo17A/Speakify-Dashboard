import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_miscellaneous_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/features/ranking/presentation/viewmodels/ranking_viewmodel.dart';
import 'package:speechlab_dashboard/features/scores/data/models/speech_model.dart';

class SelectedSpeechlabLeaderboardPage extends HookConsumerWidget {
  final String currentSpeechLevelReq;
  const SelectedSpeechlabLeaderboardPage(
      {super.key, required this.currentSpeechLevelReq});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rankingViewModelProvider);
    final viewModel = ref.read(rankingViewModelProvider.notifier);

    final currentSpeechLevel = useMemoized(
        () => int.parse(currentSpeechLevelReq), [currentSpeechLevelReq]);

    final students = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getSpeechLeaderboard(currentSpeechLevel);
      });
      return null;
    }, const []);

    ref.listen(rankingViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
      } else if (next is Success) {
        final data = next.data;
        if (data is List<Map<String, dynamic>>) {
          students.value = data;
        }
      }
    });

    Widget speechTitleHeader() {
      return Row(
        children: [
          backButton(context,
              onPress: () => GoRouter.of(context).go(AppRoutes.ranking)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: AutoSizeText(
                getSpeeechByIndex(currentSpeechLevel)!.category,
                style: wineBoldStyle(size: 40),
              )),
        ],
      );
    }

    Widget noStudentsAvailable() {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.15),
        child: Text(
            'NO STUDENT IN THIS SECTION HAS COMPLETED THIS SPEECHLAB LEVEL YET.',
            textAlign: TextAlign.center,
            style: wineBoldStyle(size: 30)),
      );
    }

    Widget rankingsContainer() {
      return students.value.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: students.value.length,
              itemBuilder: (context, index) {
                return studentSpeechRankingEntry(context,
                    index: index,
                    currentSpeechLevelReq: currentSpeechLevelReq,
                    studentData: students.value[index]);
              })
          : noStudentsAvailable();
    }

    return DashboardShell(
      navIndex: 0,
      child: switchedLoadingContainer(
          state is Loading,
          all8Pix(Column(
            children: [
              speechTitleHeader(),
              loveWineContainer(
                  SingleChildScrollView(
                      child: Column(children: [
                    rankingHeaders(context),
                    rankingsContainer()
                  ])),
                  height: MediaQuery.of(context).size.height * 0.75)
            ],
          ))),
    );
  }
}
