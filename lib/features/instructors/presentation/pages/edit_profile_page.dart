import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/color_util.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/dropdown_widget.dart';
import 'package:speechlab_dashboard/core/widgets/speechLabTextField.dart';
import 'package:speechlab_dashboard/features/instructors/presentation/viewmodels/instructors_viewmodel.dart';

class EditProfilePage extends HookConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(instructorsViewModelProvider);
    final viewModel = ref.read(instructorsViewModelProvider.notifier);

    final isLoading = useState(true);
    final pendingAction = useState<String?>(null);
    final currentSelectedFile = useState<Uint8List?>(null);
    final profileImageURL = useState('');
    final originalFirstName = useState('');
    final originalLastName = useState('');
    final handledSections = useState<List<dynamic>>([]);
    final allSelectableSections = useState<List<String>>([]);
    final allSectionsHandled = useState(false);
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final currentSelectedSection = useState('');

    void loadCurrentUserData() {
      isLoading.value = true;
      viewModel.getCurrentInstructorProfile();
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadCurrentUserData();
      });
      return null;
    }, const []);

    ref.listen(instructorsViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
        isLoading.value = false;
        pendingAction.value = null;
      } else if (next is Success) {
        final action = pendingAction.value;
        if (action == 'update') {
          pendingAction.value = null;
          currentSelectedFile.value = null;
          displayError(context, 'Successfully updated user profile!');
          loadCurrentUserData();
          return;
        }
        if (action == 'removePic') {
          pendingAction.value = null;
          currentSelectedFile.value = null;
          profileImageURL.value = '';
          isLoading.value = false;
          return;
        }
        if (action == 'addSection' || action == 'removeSection') {
          pendingAction.value = null;
          loadCurrentUserData();
          return;
        }
        final data = next.data;
        if (data is Map<String, dynamic>) {
          originalFirstName.value = data['firstName'] ?? '';
          firstNameController.text = originalFirstName.value;
          originalLastName.value = data['lastName'] ?? '';
          lastNameController.text = originalLastName.value;
          profileImageURL.value = data['profileImageURL'] ?? '';
          handledSections.value =
              List<dynamic>.from(data['handledSections'] ?? []);
          allSelectableSections.value =
              List<String>.from(data['allSelectableSections'] ?? []);
          allSectionsHandled.value = data['allSectionsHandled'] ?? false;
          isLoading.value = false;
        }
      }
    });

    void updateUserProfile() {
      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty) {
        displayError(context, 'Please fill up your first and last name');
        return;
      }
      isLoading.value = true;
      pendingAction.value = 'update';
      viewModel.updateOwnProfile(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          profileImageBytes: currentSelectedFile.value);
    }

    Future<void> pickImage() async {
      final pickedFile = await ImagePickerWeb.getImageAsBytes();
      if (pickedFile != null) {
        currentSelectedFile.value = pickedFile;
      }
    }

    void addSectionToHandle() {
      if (currentSelectedSection.value.isEmpty) return;
      GoRouter.of(context).pop();
      isLoading.value = true;
      pendingAction.value = 'addSection';
      viewModel.addSectionToHandle(currentSelectedSection.value);
    }

    void removeHandledSection() {
      if (currentSelectedSection.value.isEmpty) return;
      GoRouter.of(context).pop();
      isLoading.value = true;
      pendingAction.value = 'removeSection';
      viewModel.removeHandledSection(currentSelectedSection.value);
    }

    void showAddSectionDialog() {
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
                              'SELECT A SECTION TO HANDLE',
                              style: wineBoldStyle(size: 35),
                            ),
                            dropdownWidget(currentSelectedSection.value,
                                (selected) {
                              setDialogState(() {
                                currentSelectedSection.value = selected!;
                              });
                            }, allSelectableSections.value,
                                currentSelectedSection.value, false),
                            ElevatedButton(
                                onPressed: () => addSectionToHandle(),
                                child: all20Pix(
                                    const Text('HANDLE THIS SECTION'))),
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

    void showRemoveSectionDialog() {
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
                              'SELECT A SECTION TO REMOVE',
                              style: wineBoldStyle(size: 35),
                            ),
                            dropdownWidget(currentSelectedSection.value,
                                (selected) {
                              setDialogState(() {
                                currentSelectedSection.value = selected!;
                              });
                            }, List<String>.from(handledSections.value),
                                currentSelectedSection.value, false),
                            ElevatedButton(
                                onPressed: () => removeHandledSection(),
                                child: all20Pix(
                                    const Text('REMOVE THIS SECTION'))),
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

    Widget buildProfileImage() {
      if (currentSelectedFile.value != null) {
        return CircleAvatar(
            radius: 70,
            backgroundImage: MemoryImage(currentSelectedFile.value!));
      }
      if (profileImageURL.value != '') {
        return CircleAvatar(
          radius: 100,
          backgroundColor: CustomColors.orchid,
          backgroundImage: NetworkImage(profileImageURL.value),
        );
      } else {
        return const CircleAvatar(
            radius: 100,
            backgroundColor: CustomColors.orchid,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 80,
            ));
      }
    }

    void removeProfilePic() {
      isLoading.value = true;
      pendingAction.value = 'removePic';
      viewModel.removeOwnProfilePic();
    }

    Widget teacherProfileWidget() {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: all20Pix(
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: buildProfileImage(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        all8Pix(Text(
                            '${originalFirstName.value} ${originalLastName.value}',
                            style: wineBoldStyle(size: 40))),
                        Row(children: [
                          if (currentSelectedFile.value != null)
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    currentSelectedFile.value = null;
                                  },
                                  child:
                                      const Text('Remove Selected Picture')),
                            )
                          else if (profileImageURL.value != '')
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                  onPressed: removeProfilePic,
                                  child: const Text('Remove Current Picture')),
                            ),
                          ElevatedButton(
                              onPressed: pickImage,
                              child: const Text('Upload Profile Picture')),
                        ])
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: speechLabTextField('First Name', firstNameController,
                      TextInputType.name, null),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: speechLabTextField(
                      'Last Name', lastNameController, TextInputType.name, null),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 65,
                  child: ElevatedButton(
                      onPressed: updateUserProfile,
                      child: const Text('SAVE CHANGES',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18))),
                )
              ],
            ),
          ));
    }

    Widget handledSectionsWidget() {
      return loveWineContainer(
          all20Pix(Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!allSectionsHandled.value)
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.07,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              currentSelectedSection.value = '';
                              showAddSectionDialog();
                            },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                    color: CustomColors.orchid)),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: AutoSizeText(
                                'Add\nSection',
                                textAlign: TextAlign.center,
                                style: whiteBoldStyle(),
                              ),
                            ))),
                  if (handledSections.value.isNotEmpty)
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.07,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              currentSelectedSection.value = '';
                              showRemoveSectionDialog();
                            },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                    color: CustomColors.orchid)),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: AutoSizeText(
                                'Remove Section',
                                minFontSize: 10,
                                textAlign: TextAlign.center,
                                style: whiteBoldStyle(),
                              ),
                            ))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Handled Sections:',
                  textAlign: TextAlign.center,
                  style: wineBoldStyle(size: 30),
                ),
              ),
              handledSections.value.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: handledSections.value.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () => GoRouter.of(context).goNamed(
                                    AppRoutes.editSection,
                                    pathParameters: {
                                      'sectionName':
                                          handledSections.value[index]
                                    }),
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                        color: CustomColors.orchid,
                                        width: 3)),
                                child: Text(handledSections.value[index],
                                    textAlign: TextAlign.center,
                                    style: whiteBoldStyle(size: 20))),
                          ),
                        );
                      })
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        'NO HANDLED SECTIONS',
                        textAlign: TextAlign.center,
                        style: wineBoldStyle(size: 30),
                      ),
                    )
            ],
          )),
          width: MediaQuery.of(context).size.width * 0.2);
    }

    return DashboardShell(
      navIndex: 2,
      child: stackedLoadingContainer(
          context, isLoading.value || state is Loading, [
        Row(
          children: [teacherProfileWidget(), handledSectionsWidget()],
        ),
      ]),
    );
  }
}
