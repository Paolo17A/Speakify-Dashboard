import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                                  child: Column(children: [
                                    cambriaWineHeaderText(text: 'INSTRUCTORS'),
                                    const Divider(
                                      thickness: 5,
                                      color: CustomColors.darkWine,
                                    )
                                  ])),
                              loveWineContainer(SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: ListView.builder(
                                    itemCount: instructorDocs.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return _teacherWidget(
                                          instructorDocs[index].data());
                                    }),
                              ))
                            ],
                          ),
                        ))))
          ],
        ));
  }

  Widget _teacherWidget(dynamic instructorData) {
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () => displayInstructorDialogue(
                          context,
                          instructorData['profileImageURL'],
                          '${instructorData['firstName']} ${instructorData['lastName']}'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.orchid),
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
