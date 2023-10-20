import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../utils/firebase_util.dart';
import '../widgets/custom_padding_widgets.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;
  List<DocumentSnapshot> _userDocs = [];
  String _leaderboardType = 'currentLesson';
  String _selectedSection = 'AB Broad 3A';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _isAdmin = await isAdmin();
    _initializeLeaderboard();
  }

  void _initializeLeaderboard() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
  }

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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.15,
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
                                                color: Colors.white,
                                                fontSize: 25),
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
                                width: MediaQuery.of(context).size.width * 0.4,
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
                          loveWineContainer(
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: _userDocs.isEmpty
                                    ? const Center(
                                        child: Text(
                                            'This section has no enrolled students',
                                            style: TextStyle(
                                                color: CustomColors.orchid,
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
                                                  color: CustomColors.mercury,
                                                  border: Border.all(
                                                      color: CustomColors.wine,
                                                      width: 3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
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
                                                            0.1,
                                                        child: Center(
                                                          child: Text(
                                                              '${(_userDocs[index].data()! as Map<dynamic, dynamic>)['studentID'] ?? ''}',
                                                              style: const TextStyle(
                                                                  color:
                                                                      CustomColors
                                                                          .orchid,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child: Center(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  '${(_userDocs[index].data()! as Map<dynamic, dynamic>)['firstName']} ${(_userDocs[index].data()! as Map<dynamic, dynamic>)['lastName']}',
                                                                  style: const TextStyle(
                                                                      color: CustomColors
                                                                          .orchid,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child: Center(
                                                          child: Text(
                                                              'Current Level: ${(_userDocs[index].data()! as Map<dynamic, dynamic>)[_leaderboardType]}',
                                                              style: const TextStyle(
                                                                  color:
                                                                      CustomColors
                                                                          .orchid,
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
                              ),
                              height: MediaQuery.of(context).size.height * 0.8)
                        ]),
                      ))))
        ]));
  }
}
