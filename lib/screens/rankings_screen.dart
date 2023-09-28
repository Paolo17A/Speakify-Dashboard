// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/error_message.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  bool _isLoading = true;
  List<DocumentSnapshot> _userDocs = [];
  String _leaderboardType = 'currentLesson';
  String _selectedSection = 'AB Broad 3A';

  @override
  void initState() {
    super.initState();
    _initializeLeaderboard();
  }

  void _initializeLeaderboard() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<DocumentSnapshot> userDocs = querySnapshot.docs;

      // Filter out users without the 'currentLesson' field
      List<DocumentSnapshot> usersWithCurrentLesson = userDocs.where((userDoc) {
        Map<dynamic, dynamic> userData =
            userDoc.data()! as Map<dynamic, dynamic>;
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
      displayError(
          context, 'Error initializing leaderboard: ${error.toString()}');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(children: [
          lefNavigator(context, 0),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              color: Colors.white,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.12,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                      255, 60, 19, 97), // Border properties
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Border radius
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: DropdownButton<String>(
                                    value: _selectedSection,
                                    dropdownColor:
                                        const Color.fromARGB(255, 60, 19, 97),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedSection = newValue!;
                                        _initializeLeaderboard();
                                      });
                                    },
                                    items: [
                                      'AB Broad 3A',
                                      'AB Broad 3B',
                                      'AB Broad 4A',
                                      'AB Broad 4B'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Center(
                                  child: Text(
                                      _leaderboardType == 'currentLesson'
                                          ? 'QUIZ LESSON LEADERBOARD'
                                          : 'SPEECHLAB LEADERBOARD',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 60, 19, 97),
                                          fontSize: 55,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.12,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 60, 19, 97),
                                    borderRadius: BorderRadius.circular(10)),
                                child: IconButton(
                                    onPressed: _switchLeaderboard,
                                    icon: Icon(
                                      _leaderboardType == 'currentLesson'
                                          ? Icons.mic
                                          : Icons.quiz,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: _userDocs.isEmpty
                              ? const Center(
                                  child: Text(
                                      'This section has no enrolled students',
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold)),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _userDocs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 60, 19, 97),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Center(
                                                    child: Text(
                                                        (index + 1).toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: Center(
                                                    child: Text(
                                                        '${(_userDocs[index].data()! as Map<dynamic, dynamic>)['firstName']} ${(_userDocs[index].data()! as Map<dynamic, dynamic>)['lastName']}',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: Center(
                                                    child: Text(
                                                        'Current Level: ${(_userDocs[index].data()! as Map<dynamic, dynamic>)[_leaderboardType]}',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                    );
                                  }),
                        )
                      ]),
                    ))
        ]));
  }
}
