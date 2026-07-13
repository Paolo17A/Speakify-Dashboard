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

class SelectedQuizLeaderboardPage extends HookConsumerWidget {
  final String quizID;
  const SelectedQuizLeaderboardPage({super.key, required this.quizID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rankingViewModelProvider);
    final viewModel = ref.read(rankingViewModelProvider.notifier);

    final students = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getQuizLeaderboard(quizID);
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

    Widget quizTitleHeader() {
      return Row(
        children: [
          backButton(context,
              onPress: () => GoRouter.of(context).go(AppRoutes.ranking)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: AutoSizeText(
                quizID,
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
            'NO STUDENT IN THIS SECTION HAS COMPLETED ALL THREE QUIZZES YET',
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
                return studentQuizRankingEntry(context,
                    index: index,
                    quizTitle: quizID,
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
              quizTitleHeader(),
              loveWineContainer(
                  SingleChildScrollView(
                      child: Column(
                    children: [rankingHeaders(context), rankingsContainer()],
                  )),
                  height: MediaQuery.of(context).size.height * 0.65)
            ],
          ))),
    );
  }
}
