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
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/speechLabTextField.dart';
import 'package:speechlab_dashboard/features/lessons/presentation/viewmodels/lessons_viewmodel.dart';

class AddLessonPage extends HookConsumerWidget {
  const AddLessonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonsViewModelProvider);
    final viewModel = ref.read(lessonsViewModelProvider.notifier);

    final titleController = useTextEditingController();
    final contentController = useTextEditingController();
    final fileNameControllers = useState<List<TextEditingController>>([]);
    final downloadLinkControllers = useState<List<TextEditingController>>([]);

    ref.listen(lessonsViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
      } else if (next is Success) {
        displaySuccess(context, 'Successfully added new custom lesson!');
        GoRouter.of(context).go(AppRoutes.lessons);
      }
    });

    void addNewCustomLesson() {
      if (titleController.text.isEmpty || contentController.text.isEmpty) {
        displayError(context, 'Please fill up all fields');
        return;
      }
      for (int i = 0; i < downloadLinkControllers.value.length; i++) {
        if (fileNameControllers.value[i].text.isEmpty ||
            downloadLinkControllers.value[i].text.isEmpty) {
          displayError(context,
              'Please fill up all additional resource fields or delete unused ones.');
          return;
        } else if (!Uri.tryParse(downloadLinkControllers.value[i].text.trim())!
            .hasAbsolutePath) {
          displayError(
              context, 'The URL provided in resource #${i + 1} is invalid');
          return;
        }
      }

      List<Map<String, String>> additionalResources = [];
      for (int i = 0; i < downloadLinkControllers.value.length; i++) {
        additionalResources.add({
          'fileName': fileNameControllers.value[i].text.trim(),
          'downloadLink': downloadLinkControllers.value[i].text.trim()
        });
      }

      viewModel.addLesson(
          title: titleController.text,
          content: contentController.text,
          additionalResources: additionalResources);
    }

    return DashboardShell(
      navIndex: 3,
      child: switchedLoadingContainer(
                  state is Loading,
                  SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                  onPressed: () => GoRouter.of(context)
                                      .go(AppRoutes.lessons),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomColors.orchid),
                                  child: const Text('BACK',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ],
                        ),
                        const Gap(25),
                        const Row(
                          children: [
                            Text('Lesson Title',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        speechLabTextField('Lesson Title', titleController,
                            TextInputType.text, null),
                        const SizedBox(height: 25),
                        const Row(
                          children: [
                            Text('Lesson Content',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        speechLabTextField('Lesson Content', contentController,
                            TextInputType.multiline, null),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Additional Resources',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    fileNameControllers.value = [
                                      ...fileNameControllers.value,
                                      TextEditingController(),
                                    ];
                                    downloadLinkControllers.value = [
                                      ...downloadLinkControllers.value,
                                      TextEditingController(),
                                    ];
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomColors.orchid,
                                      shape: const CircleBorder()),
                                  child: const Icon(Icons.add,
                                      color: Colors.white),
                                ))
                          ],
                        ),
                        if (downloadLinkControllers.value.isNotEmpty)
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: downloadLinkControllers.value.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Text('Resource # ${index + 1}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300)),
                                            ],
                                          ),
                                          speechLabTextField(
                                              'Name',
                                              fileNameControllers.value[index],
                                              TextInputType.text,
                                              null),
                                          const SizedBox(height: 10),
                                          speechLabTextField(
                                              'URL',
                                              downloadLinkControllers
                                                  .value[index],
                                              TextInputType.url,
                                              null),
                                        ]),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              fileNameControllers.value = [
                                                ...fileNameControllers.value
                                              ]..removeAt(index);
                                              downloadLinkControllers.value = [
                                                ...downloadLinkControllers
                                                    .value
                                              ]..removeAt(index);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    CustomColors.orchid,
                                                shape: const CircleBorder()),
                                            child: const Icon(
                                                Icons.delete_rounded,
                                                color: Colors.white),
                                          ))
                                    ],
                                  ),
                                );
                              }),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: addNewCustomLesson,
                            child: const Text('CREATE NEW LESSON',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
