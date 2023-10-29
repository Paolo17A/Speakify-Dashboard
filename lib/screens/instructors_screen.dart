import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/instructor_profile_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../utils/color_util.dart';
import '../widgets/custom_container_widgets.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class InstructorsScreen extends StatefulWidget {
  const InstructorsScreen({super.key});

  @override
  State<InstructorsScreen> createState() => _InstructorsScreenState();
}

class _InstructorsScreenState extends State<InstructorsScreen> {
  bool _isLoading = true;
  List<DocumentSnapshot> instructorDocs = [];

  //  Edit Student
  final instructorFirstNameController = TextEditingController();
  final instructorLastNameController = TextEditingController();
  final instructorEmailController = TextEditingController();
  final instructorPasswordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllInstructors();
  }

  //  FUTURES
  //============================================================================
  Future getAllInstructors() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final allInstructors = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isNull: false)
          .where('userType', isEqualTo: 'TEACHER')
          .get();
      instructorDocs = allInstructors.docs;
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting all instructors: $error')));
    }
  }

  Future addNewInstructor() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    if (instructorFirstNameController.text.isEmpty ||
        instructorLastNameController.text.isEmpty ||
        instructorEmailController.text.isEmpty ||
        instructorPasswordController.text.isEmpty) {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text('Please fill up all fields')));
      return;
    }
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });

      final userWithThisEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: instructorEmailController.text.trim())
          .get();

      if (userWithThisEmail.docs.isNotEmpty) {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text('Email is already in use.')));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      //  Store admin's current data locally
      final currentUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final currentUserData = currentUser.data() as Map<dynamic, dynamic>;
      String userEmail = currentUserData['email'];
      String userPassword = currentUserData['password'];

      await FirebaseAuth.instance.signOut();

      //  Create new student and initialize their data.
      final newUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: instructorEmailController.text,
              password: instructorPasswordController.text);

      String newInstructorUID = newUser.user!.uid;

      //  First we update the text field-based data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newInstructorUID)
          .set({
        'email': instructorEmailController.text,
        'password': instructorPasswordController.text,
        'firstName': instructorFirstNameController.text,
        'lastName': instructorLastNameController.text,
        'userType': 'TEACHER',
        'profileImageURL': '',
        'handledSections': []
      });

      //  Sign out the newly created student and return to admin or teacher's account
      await FirebaseAuth.instance.signOut();

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully added new instructor!')));
      setState(() {
        _isLoading = false;
      });
      getAllInstructors();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error adding new student: $error')));
    }
  }

  Future editSelectedUser(String instructorUID) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    if (instructorFirstNameController.text.isEmpty ||
        instructorLastNameController.text.isEmpty) {
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
          .doc(instructorUID)
          .update({
        'firstName': instructorFirstNameController.text.trim(),
        'lastName': instructorLastNameController.text.trim()
      });
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully edited this instructor!')));
      setState(() {
        _isLoading = false;
      });
      getAllInstructors();
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error editing selected user: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future deleteSelectedInstructor(
      String instructorUID, Map<dynamic, dynamic> instructorData) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });
      //  First we remove the instructor from their handled sections
      final instructorHandledSections = instructorData['handledSections'];
      for (var section in instructorHandledSections) {
        await FirebaseFirestore.instance
            .collection('sections')
            .doc(section)
            .update({
          'instructors': FieldValue.arrayRemove([instructorUID])
        });
      }

      //  Store admin's current data locally
      final currentUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final currentUserData = currentUser.data() as Map<dynamic, dynamic>;
      String userEmail = currentUserData['email'];
      String userPassword = currentUserData['password'];
      await FirebaseAuth.instance.signOut();

      //  Sign in to the instructor's account and delete it
      String instructorEmail = instructorData['email'];
      String instructorPassword = instructorData['password'];
      final instructorToDelete = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: instructorEmail, password: instructorPassword);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(instructorToDelete.user!.uid)
          .delete();
      await instructorToDelete.user!.delete();

      //  Log-back in to admin or user's account and refresh the page
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully deleted this instructor!')));
      getAllInstructors();
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Error deleting selected instructor: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  //WIDGETS
  //============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(
          children: [
            lefNavigator(context, 2, isAdmin: true),
            bodyWidgetWhiteBG(
                context,
                switchedLoadingContainer(
                    _isLoading,
                    vertical10PixHorizontal30Pix(context,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: _instructorsHeader()),
                              loveWineContainer(SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Column(
                                  children: [
                                    _addInstructorRow(),
                                    _instructorsContainer()
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ))))
          ],
        ));
  }

  Widget _instructorsHeader() {
    return Column(
      children: [
        cambriaWineHeaderText(text: 'INSTRUCTORS'),
        const Divider(
          thickness: 5,
          color: CustomColors.darkWine,
        )
      ],
    );
  }

  Widget _addInstructorRow() {
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
                  side: BorderSide(color: CustomColors.wine, width: 2)),
              child:
                  AutoSizeText('Add Instructor', textAlign: TextAlign.center)),
        ))
      ],
    );
  }

  Widget _instructorsContainer() {
    return instructorDocs.isNotEmpty
        ? ListView.builder(
            itemCount: instructorDocs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _teacherWidget(
                  instructorDocs[index].id, instructorDocs[index].data());
            })
        : Center(
            child: Text(
            'NO INSTRUCTORS AVAILABLE',
            style: wineBoldStyle(size: 40),
          ));
  }

  Widget _teacherWidget(String instructorUID, dynamic instructorData) {
    String profileImageUrl = instructorData['profileImageURL'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 90,
          decoration: BoxDecoration(
              color: CustomColors.mercury,
              border: Border.all(color: CustomColors.wine, width: 3),
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
                          backgroundImage: NetworkImage(
                              instructorData['profileImageURL'],
                              scale: 0.5),
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
                      child: cambriaText(
                          text:
                              '${instructorData['firstName']} ${instructorData['lastName']}',
                          textStyle: const TextStyle(
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
                        child: const Text(
                          'VIEW PROFILE',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.01),
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
                          child: const Text(
                            'EDIT PROFILE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
