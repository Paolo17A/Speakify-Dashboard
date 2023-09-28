import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/instructor_profile_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

class InstructorsScreen extends StatefulWidget {
  const InstructorsScreen({super.key});

  @override
  State<InstructorsScreen> createState() => _InstructorsScreenState();
}

class _InstructorsScreenState extends State<InstructorsScreen> {
  bool _isLoading = true;
  List<DocumentSnapshot> instructorDocs = [];
  DocumentSnapshot? currentInstructor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllInstructors();
  }

  void getAllInstructors() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final allInstructors = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isNull: false)
          .where('userType', isEqualTo: 'TEACHER')
          .get();
      instructorDocs = allInstructors.docs;
      for (int i = 0; i < instructorDocs.length; i++) {
        if (instructorDocs[i].id == FirebaseAuth.instance.currentUser!.uid) {
          currentInstructor = instructorDocs[i];
          instructorDocs.removeAt(i);
          break;
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting all instructors: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(
          children: [
            lefNavigator(context, 2),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: double.infinity,
                color: Colors.white,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text('ALL INSTRUCTORS',
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45)),
                          ),
                          if (currentInstructor != null)
                            _teacherWidget(currentInstructor!.data(), true),
                          ListView.builder(
                              itemCount: instructorDocs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return _teacherWidget(
                                    instructorDocs[index].data(), false);
                              }),
                        ],
                      ))
          ],
        ));
  }

  Widget _teacherWidget(dynamic instructorData, bool isCurrentInstructor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 90,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 115, 76, 162),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 82, 48, 124),
                    child: Icon(Icons.person, color: Colors.white),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    '${instructorData['firstName']} ${instructorData['lastName']}\t\t${isCurrentInstructor ? '(YOU)' : ''}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 45,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: ElevatedButton(
                      onPressed: () => displayInstructorDialogue(
                          context,
                          instructorData['profileImageURL'],
                          '${instructorData['firstName']} ${instructorData['lastName']}',
                          isCurrentInstructor),
                      child: const Text(
                        'VIEW PROFILE',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              )
            ],
          )),
    );
  }
}
