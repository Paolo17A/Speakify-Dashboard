import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../utils/firebase_util.dart';
import '../widgets/custom_padding_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;

  //  SECTION VARIABLES
  int currentSectionIndex = 0;
  List<DocumentSnapshot> allDisplayableSections = [];
  List<String> allSectionChoices = [];
  List<DocumentSnapshot> sectionStudents = [];

  /*List<DocumentSnapshot> _userDocs = [];
  String _leaderboardType = 'currentLesson';
  String _selectedSection = 'AB Broad 3A';*/

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
      QuerySnapshot sections;
      if (_isAdmin == true) {
        sections =
            await FirebaseFirestore.instance.collection('sections').get();
        allDisplayableSections = sections.docs;
      } else {
        sections = await FirebaseFirestore.instance
            .collection('sections')
            .where('instructors',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .get();
        allDisplayableSections = sections.docs;
        if (allDisplayableSections.isEmpty) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
      allSectionChoices.clear();
      allDisplayableSections.forEach((section) {
        allSectionChoices.add(section.id);
      });

      List<dynamic> enrolledStudents = (sections.docs[selectedSection].data()
          as Map<dynamic, dynamic>)['students'];
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

      sectionStudents.sort((a, b) {
        int lessonA = a['speechLesson'];
        int lessonB = b['speechLesson'];
        return lessonA.compareTo(lessonB);
      });
      sectionStudents = sectionStudents.reversed.toList();

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

  /*void _initializeLeaderboard() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<DocumentSnapshot> userDocs = querySnapshot.docs;

      // Filter out users without the 'currentLesson' field
      List<DocumentSnapshot> usersWithCurrentLesson = userDocs.where((userDoc) {
        final userData = userDoc.data()! as Map<dynamic, dynamic>;
        return userData.containsKey(_leaderboardType) &&
            userData.containsKey('section') &&
            userData['section'] == _selectedSection;
      }).toList();

      usersWithCurrentLesson.sort((a, b) {
        int lessonA = a[_leaderboardType];
        int lessonB = b[_leaderboardType];
        return lessonA.compareTo(lessonB);
      });

      setState(() {
        _userDocs = usersWithCurrentLesson.reversed.toList();
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error initializing leaderboard: $error')));
    }
  }

  void _switchLeaderboard() {
    setState(() {
      if (_leaderboardType == 'currentLesson') {
        _leaderboardType = 'speechLesson';
      } else if (_leaderboardType == 'speechLesson') {
        _leaderboardType = 'currentLesson';
      }

      _isLoading = true;
      _initializeLeaderboard();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(children: [
          lefNavigator(context, 0, isAdmin: _isAdmin),
          bodyWidgetWhiteBG(
              context,
              switchedLoadingContainer(
                  _isLoading,
                  vertical10PixHorizontal30Pix(context,
                      child: SingleChildScrollView(
                        child: Column(children: [
                          _broadcastingSectionHeader(),
                          loveWineContainer(
                              Column(
                                children: [
                                  _sectionSelectionRow(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: whiteWineContainer(
                                        Column(
                                          children: [
                                            rankingHeaders(),
                                            sectionStudents.isEmpty
                                                ? Center(
                                                    child: Text(
                                                        'This section has no enrolled students',
                                                        style: wineBoldStyle(
                                                            size: 40)))
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        sectionStudents.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final studentData =
                                                          sectionStudents[index]
                                                                  .data()
                                                              as Map<dynamic,
                                                                  dynamic>;
                                                      return studentRankingEntry(
                                                          index, studentData);
                                                    }),
                                          ],
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7),
                                  ),
                                ],
                              ),
                              height: MediaQuery.of(context).size.height * 0.8)
                        ]),
                      ))))
        ]));
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
                itemCount: allDisplayableSections.length,
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
                          child: Text(allDisplayableSections[index].id,
                              style: index == currentSectionIndex
                                  ? blackBoldStyle()
                                  : whiteBoldStyle())),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget rankingHeaders() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
          child: Center(
            child: Text('Rank', style: wineBoldStyle()),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Center(
            child: Text('Student #', style: wineBoldStyle()),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Center(
            child: Row(
              children: [
                Text('Student Name', style: wineBoldStyle()),
              ],
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Center(
            child: Text('SpeechLab Rank', style: wineBoldStyle()),
          ),
        )
      ]),
    );
  }

  Widget studentRankingEntry(int index, Map<dynamic, dynamic> studentData) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.mercury,
            border: Border.all(color: CustomColors.wine, width: 3),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
              child: Center(
                child:
                    Text('${(index + 1).toString()}', style: wineBoldStyle()),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Center(
                child: Text(studentData['studentID'], style: wineBoldStyle()),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Center(
                child: Row(
                  children: [
                    Text(
                        '${studentData['firstName']} ${studentData['lastName']}',
                        style: wineBoldStyle()),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Center(
                child: Text('Current Level: ${studentData['speechLesson']}',
                    style: wineBoldStyle()),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
