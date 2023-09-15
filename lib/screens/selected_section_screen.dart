import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/error_message.dart';
import 'package:speechlab_dashboard/utils/student_achievements_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

class SelectedSectionScreen extends StatefulWidget {
  final String section;
  const SelectedSectionScreen({super.key, required this.section});

  @override
  State<SelectedSectionScreen> createState() => _SelectedSectionScreenState();
}

class _SelectedSectionScreenState extends State<SelectedSectionScreen> {
  List<DocumentSnapshot> _userDocs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getStudentsInSection();
  }

  void _getStudentsInSection() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<DocumentSnapshot> userDocs = querySnapshot.docs;

      _userDocs = userDocs.where((userDoc) {
        final data = userDoc.data() as Map<dynamic, dynamic>;
        return data.containsKey('userType') &&
            data['userType'] == 'STUDENT' &&
            data.containsKey('section') &&
            data['section'] == widget.section;
      }).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      // ignore: use_build_context_synchronously
      displayError(context, 'Error getting students: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  lefNavigator(context, 1),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: double.infinity,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text('Students - ${widget.section}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: _userDocs.isEmpty
                                  ? const Center(
                                      child: Text(
                                          'This section has no enrolled students',
                                          style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  : SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Container(
                                              color: const Color.fromARGB(
                                                  255, 82, 48, 124),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      child: Text(
                                                        'Student Name',
                                                        style: _headerStyle(),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      child: Text(
                                                        'Current Quiz Lesson',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: _headerStyle(),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      child: Text(
                                                        'Current SpeechLab Level',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: _headerStyle(),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                      child: Text(
                                                        'Achievements',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: _headerStyle(),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: _userDocs.length,
                                              itemBuilder: (build, index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3),
                                                  child: (Container(
                                                    color: const Color.fromARGB(
                                                        255, 103, 65, 150),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.20,
                                                            child: Row(
                                                              children: [
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4),
                                                                  child: Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Text(
                                                                    '${(_userDocs[index].data() as Map<dynamic, dynamic>)['firstName']} ${(_userDocs[index].data() as Map<dynamic, dynamic>)['lastName']}',
                                                                    style:
                                                                        _studentEntryStyle()),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.20,
                                                            child: Text(
                                                                '${(_userDocs[index].data() as Map<dynamic, dynamic>)['currentLesson']}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    _studentEntryStyle()),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.20,
                                                            child: Text(
                                                                '${(_userDocs[index].data() as Map<dynamic, dynamic>)['speechLesson']}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    _studentEntryStyle()),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.15,
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed: () => displayStudentAchievementsDialogue(
                                                                        context,
                                                                        '${(_userDocs[index].data() as Map<dynamic, dynamic>)['firstName']} ${(_userDocs[index].data() as Map<dynamic, dynamic>)['lastName']}',
                                                                        List.from((_userDocs[index].data()
                                                                                as Map<dynamic, dynamic>)[
                                                                            'achievements']),
                                                                        (_userDocs[index].data() as Map<
                                                                            dynamic,
                                                                            dynamic>)['profileImageURL']),
                                                                    child: const Text(
                                                                      'VIEW ACHIEVEMENTS',
                                                                      style: TextStyle(
                                                                          letterSpacing:
                                                                              2),
                                                                    )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }

  TextStyle _headerStyle() {
    return const TextStyle(
        fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
  }

  TextStyle _studentEntryStyle() {
    return const TextStyle(fontSize: 20, color: Colors.white);
  }
}
