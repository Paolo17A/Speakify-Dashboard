import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/session/auth_session_notifier.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/color_util.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_miscellaneous_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/features/lessons/presentation/viewmodels/lessons_viewmodel.dart';

class LessonsPage extends HookConsumerWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonsViewModelProvider);
    final viewModel = ref.read(lessonsViewModelProvider.notifier);
    final isAdmin = ref.read(authSessionProvider).isAdmin;

    final customLessons = useState<List<Map<String, dynamic>>>([]);
    final pendingAction = useState<String?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getAllLessons();
      });
      return null;
    }, const []);

    ref.listen(lessonsViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
        pendingAction.value = null;
      } else if (next is Success) {
        if (pendingAction.value == 'delete') {
          pendingAction.value = null;
          displayError(context, 'Successfully deleted this lesson.');
          viewModel.getAllLessons();
          return;
        }
        final data = next.data;
        if (data is List<Map<String, dynamic>>) {
          customLessons.value = data;
        }
      }
    });

    void deleteLesson(String lessonID) {
      pendingAction.value = 'delete';
      viewModel.deleteLesson(lessonID);
    }

    Widget customLessonsHeader() {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(children: [
            AutoSizeText('CUSTOM LESSONS', style: wineBoldStyle(size: 40)),
            const Divider(
              thickness: 5,
              color: CustomColors.orchid,
            )
          ]));
    }

    Widget customLessonContainer() {
      return customLessons.value.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  width: double.infinity,
                  height: isAdmin
                      ? MediaQuery.of(context).size.height * 0.75
                      : MediaQuery.of(context).size.height * 0.65,
                  child: SingleChildScrollView(
                    child: Column(
                        children: customLessons.value.map((lesson) {
                      return vertical10PixHorizontal30Pix(context,
                          child: lessonEntryWithActionsContainer(context,
                              label: lesson['lessonTitle'] ?? '',
                              editFunction: () {
                                GoRouter.of(context).goNamed(
                                    AppRoutes.editLesson,
                                    pathParameters: {'lessonID': lesson['id']});
                              },
                              deleteFunction: () => deleteLesson(lesson['id']),
                              mayEditLesson: !isAdmin));
                    }).toList()),
                  )),
            )
          : SizedBox(
              height: isAdmin
                  ? MediaQuery.of(context).size.height * 0.75
                  : MediaQuery.of(context).size.height * 0.65,
              child: const Center(
                  child: AutoSizeText('NO CUSTOM LESSONS AVAILABLE',
                      style: TextStyle(
                          color: CustomColors.orchid,
                          fontSize: 40,
                          fontWeight: FontWeight.bold))),
            );
    }

    return DashboardShell(
      navIndex: 3,
      child: switchedLoadingContainer(
                  state is Loading,
                  SingleChildScrollView(
                      child: all8Pix(Column(children: [
                    customLessonsHeader(),
                    loveWineContainer(Column(children: [
                      if (!isAdmin)
                        addEntryButton(context,
                            label: 'ADD NEW LESSON',
                            onPress: () =>
                                GoRouter.of(context).go(AppRoutes.addLesson)),
                      customLessonContainer()
                    ]))
                  ])))),
    );
  }
}
