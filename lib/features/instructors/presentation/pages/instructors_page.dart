import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speechlab_dashboard/core/utils/color_util.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/features/instructors/presentation/viewmodels/instructors_viewmodel.dart';
import 'package:speechlab_dashboard/features/instructors/presentation/widgets/instructor_dialogs.dart';

class InstructorsPage extends HookConsumerWidget {
  const InstructorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(instructorsViewModelProvider);
    final viewModel = ref.read(instructorsViewModelProvider.notifier);

    final instructors = useState<List<Map<String, dynamic>>>([]);
    final pendingAction = useState<String?>(null);

    final instructorFirstNameController = useTextEditingController();
    final instructorLastNameController = useTextEditingController();
    final instructorEmailController = useTextEditingController();
    final instructorPasswordController = useTextEditingController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getAllInstructors();
      });
      return null;
    }, const []);

    ref.listen(instructorsViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
        pendingAction.value = null;
      } else if (next is Success) {
        final action = pendingAction.value;
        if (action != null) {
          pendingAction.value = null;
          if (action == 'add') {
            displayError(context, 'Successfully added new instructor!');
          } else if (action == 'edit') {
            displayError(context, 'Successfully edited this instructor!');
          } else if (action == 'delete') {
            displayError(context, 'Successfully deleted this instructor!');
          }
          viewModel.getAllInstructors();
          return;
        }
        final data = next.data;
        if (data is List<Map<String, dynamic>>) {
          instructors.value = data;
        }
      }
    });

    void addNewInstructor() {
      if (instructorFirstNameController.text.isEmpty ||
          instructorLastNameController.text.isEmpty ||
          instructorEmailController.text.isEmpty ||
          instructorPasswordController.text.isEmpty) {
        displayError(context, 'Please fill up all fields');
        return;
      }
      Navigator.of(context).pop();
      pendingAction.value = 'add';
      viewModel.addInstructor(
          firstName: instructorFirstNameController.text,
          lastName: instructorLastNameController.text,
          email: instructorEmailController.text,
          password: instructorPasswordController.text);
    }

    void editSelectedUser(String instructorUID) {
      if (instructorFirstNameController.text.isEmpty ||
          instructorLastNameController.text.isEmpty) {
        displayError(context, 'Please fill up all fields');
        return;
      }
      Navigator.of(context).pop();
      pendingAction.value = 'edit';
      viewModel.editInstructor(
          instructorUID: instructorUID,
          firstName: instructorFirstNameController.text,
          lastName: instructorLastNameController.text);
    }

    void deleteSelectedInstructor(
        String instructorUID, Map<String, dynamic> instructorData) {
      Navigator.of(context).pop();
      pendingAction.value = 'delete';
      viewModel.deleteInstructor(
          instructorUID: instructorUID, instructorData: instructorData);
    }

    Widget instructorsHeader() {
      return Column(
        children: [
          AutoSizeText('INSTRUCTORS', style: wineBoldStyle(size: 40)),
          const Divider(
            thickness: 5,
            color: CustomColors.orchid,
          )
        ],
      );
    }

    Widget addInstructorRow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          all20Pix(SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: 40,
            child: ElevatedButton(
                onPressed: () => showAddInstructorDialog(
                    context,
                    instructorFirstNameController,
                    instructorLastNameController,
                    instructorEmailController,
                    instructorPasswordController,
                    addNewInstructor),
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.orchid,
                    side:
                        const BorderSide(color: CustomColors.orchid, width: 2)),
                child: const AutoSizeText('Add Instructor',
                    textAlign: TextAlign.center)),
          ))
        ],
      );
    }

    Widget teacherWidget(
        String instructorUID, Map<String, dynamic> instructorData) {
      String profileImageUrl = instructorData['profileImageURL'] ?? '';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 90,
            decoration: BoxDecoration(
                color: CustomColors.mercury,
                border: Border.all(color: CustomColors.orchid, width: 3),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (profileImageUrl.isNotEmpty)
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: CustomColors.orchid,
                            backgroundImage:
                                NetworkImage(profileImageUrl, scale: 0.5),
                          )),
                    if (profileImageUrl.isEmpty)
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: CustomColors.orchid,
                            child: Icon(Icons.person, color: Colors.white),
                          )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: AutoSizeText(
                            '${instructorData['firstName']} ${instructorData['lastName']}',
                            style: const TextStyle(
                                color: CustomColors.orchid,
                                fontWeight: FontWeight.bold,
                                fontSize: 25))),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () => displayInstructorDialogue(
                                  context, instructorData, () {
                                deleteSelectedInstructor(
                                    instructorUID, instructorData);
                              }),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.orchid),
                          child: Text(
                            'VIEW PROFILE',
                            textAlign: TextAlign.center,
                            style: whiteBoldStyle(),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 0.01),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () => showEditInstructorDialog(
                                context,
                                instructorData,
                                instructorFirstNameController,
                                instructorLastNameController,
                                () => editSelectedUser(instructorUID)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.orchid),
                            child: Text(
                              'EDIT PROFILE',
                              textAlign: TextAlign.center,
                              style: whiteBoldStyle(),
                            )),
                      ),
                    ),
                  ],
                )
              ],
            )),
      );
    }

    Widget instructorsContainer() {
      return instructors.value.isNotEmpty
          ? ListView.builder(
              itemCount: instructors.value.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return teacherWidget(instructors.value[index]['uid'],
                    instructors.value[index]);
              })
          : Center(
              child: Text(
              'NO INSTRUCTORS AVAILABLE',
              style: wineBoldStyle(size: 40),
            ));
    }

    return DashboardShell(
        navIndex: 2,
        child: switchedLoadingContainer(
            state is Loading,
            vertical10PixHorizontal30Pix(context,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                          width: MediaQuery.of(context).size.width *
                              (MediaQuery.sizeOf(context).width < 900
                                  ? 0.95
                                  : 0.6),
                          child: instructorsHeader()),
                      loveWineContainer(SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          children: [
                            addInstructorRow(),
                            instructorsContainer()
                          ],
                        ),
                      ))
                    ],
                  ),
                ))));
  }
}
