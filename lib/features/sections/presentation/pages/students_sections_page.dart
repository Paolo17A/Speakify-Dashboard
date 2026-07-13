import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechlab_dashboard/core/session/auth_session_notifier.dart';
import 'package:speechlab_dashboard/core/utils/color_util.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/dropdown_widget.dart';
import 'package:speechlab_dashboard/core/widgets/speechLabTextField.dart';
import 'package:speechlab_dashboard/features/sections/presentation/viewmodels/sections_viewmodel.dart';
import 'package:speechlab_dashboard/features/sections/presentation/widgets/student_achievements_dialog.dart';

class StudentsSectionsPage extends HookConsumerWidget {
  const StudentsSectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sectionsViewModelProvider);
    final viewModel = ref.read(sectionsViewModelProvider.notifier);
    final isAdmin = ref.read(authSessionProvider).isAdmin;

    final currentSectionIndex = useState(0);
    final allSectionChoices = useState<List<String>>([]);
    final sectionStudents = useState<List<Map<String, dynamic>>>([]);
    final pendingAction = useState<String?>(null);

    final sectionNameController = useTextEditingController();
    final studentIDController = useTextEditingController();
    final studentFirstNameController = useTextEditingController();
    final studentLastNameController = useTextEditingController();
    final studentEmailController = useTextEditingController();
    final currentSelectedSection = useState('');

    void loadSectionStudents(String sectionName) {
      viewModel.getSectionStudents(sectionName);
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.getAccessibleSectionNames();
      });
      return null;
    }, const []);

    ref.listen(sectionsViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
        pendingAction.value = null;
      } else if (next is Success) {
        if (pendingAction.value != null) {
          pendingAction.value = null;
          viewModel.getAccessibleSectionNames();
          return;
        }
        final data = next.data;
        if (data is List<String>) {
          allSectionChoices.value = data;
          if (data.isEmpty) {
            sectionStudents.value = [];
            return;
          }
          final targetIndex = currentSectionIndex.value >= data.length
              ? 0
              : currentSectionIndex.value;
          currentSectionIndex.value = targetIndex;
          loadSectionStudents(data[targetIndex]);
        } else if (data is List<Map<String, dynamic>>) {
          sectionStudents.value = data;
        }
      }
    });

    void showAddSectionDialog() {
      sectionNameController.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: CustomColors.love,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: CustomColors.orchid, width: 3)),
                child: all20Pix(Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'ADD SECTION',
                      style: TextStyle(
                          color: CustomColors.orchid,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SpeechLabTextField(
                        text: 'Section Name',
                        controller: sectionNameController,
                        textInputType: TextInputType.text,
                        displayPrefixIcon: null,
                        color: CustomColors.orchid),
                    ElevatedButton(
                        onPressed: () {
                          if (sectionNameController.text.isEmpty) {
                            displayError(
                                context, 'Please provide a section name.');
                            return;
                          }
                          GoRouter.of(context).pop();
                          pendingAction.value = 'addSection';
                          viewModel.addSection(sectionNameController.text);
                        },
                        child: all20Pix(const Text('ADD NEW SECTION'))),
                    const Gap(50),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('\tCLOSE\t')),
                  ],
                )),
              ),
            );
          });
    }

    void showEditProfileDialog(
        String studentUID, Map<String, dynamic> studentData) {
      showDialog(
          context: context,
          builder: (context) {
            String profileImageURL = studentData['profileImageURL'] ?? '';
            studentIDController.text = studentData['studentID'] ?? '';
            studentFirstNameController.text = studentData['firstName'] ?? '';
            studentLastNameController.text = studentData['lastName'] ?? '';
            currentSelectedSection.value = studentData['section'] ?? '';

            return AlertDialog(
              backgroundColor: CustomColors.love,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: CustomColors.orchid, width: 3)),
                child: SingleChildScrollView(
                  child: all20Pix(StatefulBuilder(
                      builder: (context, setDialogState) => Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              profileImageURL.isEmpty
                                  ? const CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.person,
                                        size: 70,
                                        color: CustomColors.orchid,
                                      ))
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          profileImageURL,
                                          scale: 1)),
                              const SizedBox(height: 20),
                              Row(children: [
                                Text('Student ID Number',
                                    style: wineBoldStyle(size: 20))
                              ]),
                              SpeechLabTextField(
                                  text: 'Student ID #:',
                                  controller: studentIDController,
                                  textInputType: TextInputType.number,
                                  displayPrefixIcon: null,
                                  color: CustomColors.orchid),
                              const SizedBox(height: 10),
                              Row(children: [
                                Text('First Name',
                                    style: wineBoldStyle(size: 20))
                              ]),
                              SpeechLabTextField(
                                  text: 'First Name',
                                  controller: studentFirstNameController,
                                  textInputType: TextInputType.number,
                                  displayPrefixIcon: null,
                                  color: CustomColors.orchid),
                              const SizedBox(height: 10),
                              Row(children: [
                                Text('Last Name',
                                    style: wineBoldStyle(size: 20))
                              ]),
                              SpeechLabTextField(
                                  text: 'Last Name',
                                  controller: studentLastNameController,
                                  textInputType: TextInputType.number,
                                  displayPrefixIcon: null,
                                  color: CustomColors.orchid),
                              const SizedBox(height: 10),
                              Row(children: [
                                Text('Section', style: wineBoldStyle(size: 20))
                              ]),
                              dropdownWidget(currentSelectedSection.value,
                                  (selected) {
                                setDialogState(() {
                                  currentSelectedSection.value = selected!;
                                });
                              }, allSectionChoices.value,
                                  currentSelectedSection.value, false),
                              const Gap(20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: 40,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (studentFirstNameController
                                                  .text.isEmpty ||
                                              studentLastNameController
                                                  .text.isEmpty ||
                                              studentIDController
                                                  .text.isEmpty) {
                                            displayError(context,
                                                'Please fill up all fields');
                                            return;
                                          }
                                          GoRouter.of(context).pop();
                                          final oldSection = sectionStudents
                                                      .value
                                                  .firstWhere(
                                                      (s) =>
                                                          s['uid'] ==
                                                          studentUID,
                                                      orElse: () => {})[
                                              'section'] as String? ??
                                              allSectionChoices.value[
                                                  currentSectionIndex.value];
                                          pendingAction.value = 'editStudent';
                                          viewModel.editStudent(
                                              studentUID: studentUID,
                                              studentID:
                                                  studentIDController.text,
                                              firstName:
                                                  studentFirstNameController
                                                      .text,
                                              lastName:
                                                  studentLastNameController
                                                      .text,
                                              oldSection: oldSection,
                                              newSection:
                                                  currentSelectedSection
                                                      .value);
                                        },
                                        child: const Text('Edit Student')),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: 40,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          GoRouter.of(context).pop();
                                          pendingAction.value = 'deleteStudent';
                                          viewModel.deleteStudent(
                                              studentUID: studentUID,
                                              studentData: studentData);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color
                                                .fromARGB(255, 161, 11, 0)),
                                        child: const Text('Delete Student')),
                                  )
                                ],
                              ),
                              const Gap(50),
                              ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('\tCLOSE\t')),
                            ],
                          ))),
                ),
              ),
            );
          });
    }

    void showAddNewStudentDialog() {
      studentIDController.clear();
      studentFirstNameController.clear();
      studentLastNameController.clear();
      studentEmailController.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: CustomColors.love,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: CustomColors.orchid, width: 3)),
                child: SingleChildScrollView(
                  child: all20Pix(Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(children: [
                        Text('Student ID Number',
                            style: wineBoldStyle(size: 20))
                      ]),
                      SpeechLabTextField(
                          text: 'Student ID #:',
                          controller: studentIDController,
                          textInputType: TextInputType.number,
                          displayPrefixIcon: null,
                          color: CustomColors.orchid),
                      const SizedBox(height: 10),
                      Row(children: [
                        Text('First Name', style: wineBoldStyle(size: 20))
                      ]),
                      SpeechLabTextField(
                          text: 'First Name',
                          controller: studentFirstNameController,
                          textInputType: TextInputType.number,
                          displayPrefixIcon: null,
                          color: CustomColors.orchid),
                      const SizedBox(height: 10),
                      Row(children: [
                        Text('Last Name', style: wineBoldStyle(size: 20))
                      ]),
                      SpeechLabTextField(
                          text: 'Last Name',
                          controller: studentLastNameController,
                          textInputType: TextInputType.number,
                          displayPrefixIcon: null,
                          color: CustomColors.orchid),
                      const SizedBox(height: 10),
                      Row(children: [
                        Text('Email Address', style: wineBoldStyle(size: 20))
                      ]),
                      SpeechLabTextField(
                          text: 'Email Address',
                          controller: studentEmailController,
                          textInputType: TextInputType.emailAddress,
                          displayPrefixIcon: null,
                          color: CustomColors.orchid),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              if (studentFirstNameController.text.isEmpty ||
                                  studentLastNameController.text.isEmpty ||
                                  studentIDController.text.isEmpty ||
                                  studentEmailController.text.isEmpty) {
                                displayError(
                                    context, 'Please fill up all fields');
                                return;
                              }
                              GoRouter.of(context).pop();
                              pendingAction.value = 'addStudent';
                              viewModel.addStudent(
                                  studentID: studentIDController.text,
                                  firstName: studentFirstNameController.text,
                                  lastName: studentLastNameController.text,
                                  email: studentEmailController.text,
                                  section: allSectionChoices
                                      .value[currentSectionIndex.value]);
                            },
                            child: Text(
                                'Add Student to Section ${allSectionChoices.value[currentSectionIndex.value]}')),
                      ),
                      const Gap(50),
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('\tCLOSE\t')),
                    ],
                  )),
                ),
              ),
            );
          });
    }

    Widget broadcastingSectionHeader() {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(children: [
            AutoSizeText('Broadcasting Section', style: wineBoldStyle(size: 40)),
            const Divider(
              thickness: 5,
              color: CustomColors.orchid,
            )
          ]));
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
                  itemCount: allSectionChoices.value.length,
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
                              loadSectionStudents(
                                  allSectionChoices.value[index]);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    index == currentSectionIndex.value
                                        ? Colors.white
                                        : CustomColors.orchid),
                            child: Text(allSectionChoices.value[index],
                                style: index == currentSectionIndex.value
                                    ? blackBoldStyle()
                                    : whiteBoldStyle())),
                      ),
                    );
                  }),
            ),
            if (isAdmin)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                child: ElevatedButton(
                    onPressed: () => showAddSectionDialog(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.orchid,
                        side: const BorderSide(
                            color: CustomColors.orchid, width: 2)),
                    child: const AutoSizeText('Add Section',
                        textAlign: TextAlign.center)),
              ),
            if (allSectionChoices.value.isNotEmpty)
              if (isAdmin)
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                    child: ElevatedButton(
                      onPressed: () => showAddNewStudentDialog(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.orchid,
                          side: const BorderSide(
                              color: CustomColors.orchid, width: 2)),
                      child: const AutoSizeText('Add Student',
                          textAlign: TextAlign.center),
                    ))
              else
                SizedBox(
                  width: 30,
                  child: ElevatedButton(
                    onPressed: () => showAddNewStudentDialog(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.orchid,
                        shape: const CircleBorder()),
                    child: Column(
                      children: [
                        AutoSizeText('+',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.comicNeue(fontSize: 35)),
                        const Gap(5)
                      ],
                    ),
                  ),
                )
          ],
        ),
      );
    }

    Widget studentHeaderRow() {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
              child: Text(
                'No.',
                style: wineBoldStyle(size: 25),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Text('Student #', style: wineBoldStyle(size: 25)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                'Student Name',
                style: wineBoldStyle(size: 25),
              ),
            ),
          ],
        ),
      );
    }

    Widget studentEntryRow(int index, Map<String, dynamic> studentData) {
      String studentID = studentData['studentID'] ?? '';
      String formattedName =
          '${studentData['lastName']}, ${studentData['firstName']}';
      int quizzesTaken =
          (studentData['customQuizResults'] as Map<dynamic, dynamic>? ?? {})
              .length;
      int speechLabLevel = studentData['speechLesson'] ?? 1;
      List<String> achievements =
          List<String>.from(studentData['achievements'] ?? []);
      String profileImageURL = studentData['profileImageURL'] ?? '';
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: whiteWineContainer(
              Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: Text((index + 1).toString(),
                          style: wineBoldStyle()),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(studentID, style: wineBoldStyle()),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Text(formattedName, style: wineBoldStyle()),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                                onPressed: () =>
                                    displayStudentAchievementsDialogue(
                                        context,
                                        studentID,
                                        formattedName,
                                        quizzesTaken,
                                        speechLabLevel,
                                        achievements,
                                        profileImageURL),
                                child: Text(
                                  'View Profile',
                                  style: whiteBoldStyle(),
                                )),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                              onPressed: () => showEditProfileDialog(
                                  studentData['uid'], studentData),
                              icon: const Icon(
                                Icons.settings,
                                color: CustomColors.orchid,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              borderWidth: 1));
    }

    Widget studentsContainer() {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: allSectionChoices.value.isNotEmpty
            ? all8Pix(whiteWineContainer(
                sectionStudents.value.isEmpty
                    ? Center(
                        child: Text('This section has no enrolled students',
                            style: wineBoldStyle(size: 50)),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              studentHeaderRow(),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: sectionStudents.value.length,
                                itemBuilder: (build, index) {
                                  final studentData =
                                      sectionStudents.value[index];
                                  return studentEntryRow(index, studentData);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                borderWidth: 2))
            : Text(
                'You do not have any assigned sections',
                style: wineBoldStyle(size: 30),
              ),
      );
    }

    return DashboardShell(
      navIndex: 1,
      child: switchedLoadingContainer(
        state is Loading,
        SingleChildScrollView(
            child: all8Pix(Column(
          children: [
            broadcastingSectionHeader(),
            loveWineContainer(Column(
              children: [
                sectionSelectionRow(),
                studentsContainer(),
              ],
            ))
          ],
        ))),
      ),
    );
  }
}
