import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/student_achievements_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/dropdown_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';
import 'package:speechlab_dashboard/widgets/speechLabTextField.dart';

import '../utils/color_util.dart';
import '../utils/firebase_util.dart';
import '../widgets/custom_text_widgets.dart';

class StudentsSectionsScreen extends StatefulWidget {
  const StudentsSectionsScreen({super.key});

  @override
  State<StudentsSectionsScreen> createState() => _StudentsSectionsScreenState();
}

class _StudentsSectionsScreenState extends State<StudentsSectionsScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;
  int currentSectionIndex = 0;
  List<DocumentSnapshot> allSections = [];
  List<String> allSectionChoices = [];
  List<DocumentSnapshot> sectionStudents = [];
  final sectionNameController = TextEditingController();

  //  Edit Student
  final studentIDController = TextEditingController();
  final studentFirstNameController = TextEditingController();
  final studentLastNameController = TextEditingController();
  String _currentSelectedSection = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _isAdmin = await isAdmin();

    getAllSections(currentSectionIndex);
  }

  Future getAllSections(int selectedSection) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      setState(() {
        _isLoading = true;
      });
      final sections =
          await FirebaseFirestore.instance.collection('sections').get();
      allSections = sections.docs;
      allSectionChoices.clear();
      allSections.forEach((section) {
        allSectionChoices.add(section.id);
      });

      List<dynamic> enrolledStudents =
          sections.docs[selectedSection].data()['students'];
      getSectionStudents(enrolledStudents);
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting all sections: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future getSectionStudents(List<dynamic> studentUIDs) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final students = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'STUDENT')
          .get();
      sectionStudents = students.docs.where((student) {
        return studentUIDs.contains(student.id);
      }).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting all sections: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showAddSectionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.love,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.wine, width: 3)),
              child: all20Pix(Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'ADD SECTION',
                    style: TextStyle(
                        color: CustomColors.wine,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SpeechLabTextField(
                      text: 'Section Name',
                      controller: sectionNameController,
                      textInputType: TextInputType.text,
                      displayPrefixIcon: null,
                      color: CustomColors.wine),
                  ElevatedButton(
                      onPressed: () => addNewSection(),
                      child: all20Pix(Text('ADD NEW SECTION')))
                ],
              )),
            ),
          );
        });
  }

  void showEditProfileDialog(
      String studentUID, Map<dynamic, dynamic> studentData) {
    showDialog(
        context: context,
        builder: (context) {
          String profileImageURL = studentData['profileImageURL'];
          studentIDController.text = studentData['studentID'];
          studentFirstNameController.text = studentData['firstName'];
          studentLastNameController.text = studentData['lastName'];
          _currentSelectedSection = studentData['section'];

          return AlertDialog(
            backgroundColor: CustomColors.love,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.wine, width: 3)),
              child: all20Pix(Column(
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
                          backgroundImage:
                              NetworkImage(profileImageURL, scale: 1)),
                  const SizedBox(height: 50),
                  Text(
                    'Student ID Number',
                    style: TextStyle(
                        color: CustomColors.wine,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SpeechLabTextField(
                      text: 'Student ID #:',
                      controller: studentIDController,
                      textInputType: TextInputType.number,
                      displayPrefixIcon: null,
                      color: CustomColors.wine),
                  Text(
                    'First Name',
                    style: TextStyle(
                        color: CustomColors.wine,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SpeechLabTextField(
                      text: 'First Name',
                      controller: studentFirstNameController,
                      textInputType: TextInputType.number,
                      displayPrefixIcon: null,
                      color: CustomColors.wine),
                  Text(
                    'First Name',
                    style: TextStyle(
                        color: CustomColors.wine,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SpeechLabTextField(
                      text: 'Last Name',
                      controller: studentLastNameController,
                      textInputType: TextInputType.number,
                      displayPrefixIcon: null,
                      color: CustomColors.wine),
                  Text(
                    'Section',
                    style: TextStyle(
                        color: CustomColors.wine,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  dropdownWidget(_currentSelectedSection, (selected) {
                    setState(() {
                      _currentSelectedSection = selected!;
                    });
                  }, allSectionChoices, _currentSelectedSection, false),
                  ElevatedButton(
                      onPressed: () => editSelectedUser(studentUID),
                      child: all20Pix(Text('Edit User')))
                ],
              )),
            ),
          );
        });
  }

  Future addNewSection() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    if (sectionNameController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Please provide a section name.')));
      return;
    }
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('sections')
          .doc(sectionNameController.text.trim())
          .set({
        'instructors': [],
        'students': [],
        'accessedQuizzes': [],
        'accessedLessons': []
      });
      getAllSections(currentSectionIndex);
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error adding new section: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future editSelectedUser(String clientUID) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    if (studentFirstNameController.text.isEmpty ||
        studentLastNameController.text.isEmpty ||
        studentIDController.text.isEmpty) {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text('Please fill up all fields')));
      return;
    }
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });

      //  First we update the text field-based data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(clientUID)
          .update({
        'studentID': studentIDController.text.trim(),
        'firstName': studentFirstNameController.text.trim(),
        'lastName': studentLastNameController.text.trim()
      });

      //  We get the client's current section
      final client = await FirebaseFirestore.instance
          .collection('users')
          .doc(clientUID)
          .get();
      final clientData = client.data() as Map<dynamic, dynamic>;
      String oldSection = clientData['section'];
      //  we update the sections again if the admin changed the client's section
      if (oldSection != _currentSelectedSection) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(clientUID)
            .update({'section': _currentSelectedSection});

        await FirebaseFirestore.instance
            .collection('sections')
            .doc(oldSection)
            .update({
          'students': FieldValue.arrayRemove([clientUID])
        });

        await FirebaseFirestore.instance
            .collection('sections')
            .doc(_currentSelectedSection)
            .update({
          'students': FieldValue.arrayUnion([clientUID])
        });
      }

      setState(() {
        _isLoading = false;
      });
      getAllSections(currentSectionIndex);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error editing selected user: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle(),
      body: Row(
        children: [
          lefNavigator(context, 1, isAdmin: _isAdmin),
          bodyWidgetWhiteBG(
              context,
              switchedLoadingContainer(
                _isLoading,
                SingleChildScrollView(
                    child: all8Pix(Column(
                  children: [
                    _broadcastingSectionHeader(),
                    loveWineContainer(Column(
                      children: [
                        _sectionSelectionRow(),
                        _studentsContainer(),
                      ],
                    ))
                  ],
                ))),
              ))
        ],
      ),
    );
  }

  Widget _broadcastingSectionHeader() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(children: [
          cambriaWineHeaderText(text: 'Broadcasting Section'),
          const Divider(
            thickness: 5,
            color: CustomColors.darkWine,
          )
        ]));
  }

  Widget _sectionSelectionRow() {
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
                itemCount: allSections.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () {
                            if (currentSectionIndex == index) {
                              return;
                            }
                            currentSectionIndex = index;
                            getAllSections(currentSectionIndex);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: index == currentSectionIndex
                                  ? Colors.white
                                  : CustomColors.orchid),
                          child: Text(allSections[index].id,
                              style: index == currentSectionIndex
                                  ? blackBoldStyle()
                                  : whiteBoldStyle())),
                    ),
                  );
                }),
          ),
          if (_isAdmin)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
              child: Transform.scale(
                scale: 1.5,
                child: ElevatedButton(
                    onPressed: () => showAddSectionDialog(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.orchid,
                        shape: CircleBorder(),
                        side: BorderSide(color: CustomColors.wine, width: 2)),
                    child: Icon(Icons.add)),
              ),
            )
        ],
      ),
    );
  }

  Widget _studentsContainer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: all8Pix(whiteWineContainer(
          sectionStudents.isEmpty
              ? const Center(
                  child: Text('This section has no enrolled students',
                      style: TextStyle(
                          color: CustomColors.wine,
                          fontSize: 50,
                          fontWeight: FontWeight.bold)),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        _studentHeaderRow(),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: sectionStudents.length,
                          itemBuilder: (build, index) {
                            final studentData = sectionStudents[index].data()
                                as Map<dynamic, dynamic>;
                            return _studentEntryRow(index, studentData);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
          borderWidth: 2)),
    );
  }

  Widget _studentHeaderRow() {
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

  Widget _studentEntryRow(int index, Map<dynamic, dynamic> studentData) {
    String studentID = studentData['studentID'];
    String formattedName =
        '${studentData['lastName']}, ${studentData['firstName']}';
    int quizzesTaken =
        (studentData['customQuizResults'] as Map<dynamic, dynamic>).length;
    int speechLabLevel = studentData['speechLesson'];
    List<String> achievements = List.from(studentData['achievements']);
    String profileImageURL = studentData['profileImageURL'];
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: whiteWineContainer(
            Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: Text('${(index + 1).toString()}',
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
                                sectionStudents[index].id, studentData),
                            icon: Icon(
                              Icons.settings,
                              color: CustomColors.wine,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            borderWidth: 1));
  }
}
