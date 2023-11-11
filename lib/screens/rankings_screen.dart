import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../models/speech_model.dart';
import '../utils/firebase_util.dart';
import '../widgets/custom_buttons_widget.dart';
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
  bool _viewingQuizScores = true;

  //  SECTION VARIABLES
  int currentSectionIndex = 0;
  List<DocumentSnapshot> allDisplayableSections = [];
  List<String> allSectionChoices = [];

  // QUIZ VARIABLES
  List<DocumentSnapshot> allCustomQuizzes = [];
  List<DocumentSnapshot> accessedCustomQuizzes = [];

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

      //  Get all accessed sections
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
      }
      if (allDisplayableSections.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get the current section's accessed quizzes
      final allQuizzes =
          await FirebaseFirestore.instance.collection('quizzes').get();
      allCustomQuizzes = allQuizzes.docs;
      setDisplayedQuizzes();
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

  void setDisplayedQuizzes() {
    accessedCustomQuizzes = allCustomQuizzes.where((lesson) {
      final currentSectionData = allDisplayableSections[currentSectionIndex]
          .data() as Map<dynamic, dynamic>;
      final sectionAccessedQuizzes = currentSectionData['accessedQuizzes'];
      return sectionAccessedQuizzes.contains(lesson.id);
    }).toList();
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
                          _broadcastingSectionHeader(),
                          loveWineContainer(
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _scoreChoiceSelector(),
                                    _sectionSelectionRow(),
                                    if (_viewingQuizScores)
                                      _quizzesWidget()
                                    else
                                      _speechScoresWidget()

                                    /*Padding(
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
                                                      })
                                            ],
                                          ),
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.55),
                                    ),*/
                                  ],
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.8)
                        ]),
                      ))))
        ]));
  }

  Widget _broadcastingSectionHeader() {
    return Row(
      children: [
        backButton(context, onPress: () => GoRouter.of(context).go('/home')),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(children: [
              AutoSizeText('Leaderboard', style: wineBoldStyle(size: 40)),
              const Divider(
                thickness: 5,
                color: CustomColors.darkWine,
              )
            ])),
      ],
    );
  }

  Widget _scoreChoiceSelector() {
    return all20Pix(
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      scoreOptionButton(context,
          label: 'Lesson Quiz Leaderboard',
          isSelected: _viewingQuizScores, onPress: () {
        setState(() => _viewingQuizScores = true);
      }),
      scoreOptionButton(context,
          label: 'SpeechLab Leaderboard',
          isSelected: !_viewingQuizScores, onPress: () {
        setState(() => _viewingQuizScores = false);
      })
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
                            setState(() {
                              currentSectionIndex = index;
                              setDisplayedQuizzes();
                            });
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

  Widget _quizzesWidget() {
    return Column(
        children: accessedCustomQuizzes
            .map((customQuiz) => vertical10PixHorizontal30Pix(context,
                child:
                    longEntryButton(context, label: customQuiz.id, onPress: () {
                  GoRouter.of(context).goNamed('quizRanking',
                      pathParameters: {'quizID': customQuiz.id});
                })))
            .toList());
  }

  Widget _speechScoresWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: MediaQuery.of(context).size.width * 0.02,
        runSpacing: MediaQuery.of(context).size.width * 0.01,
        children: speechCategories.asMap().entries.map((entry) {
          final int index = entry.key;
          final SpeechModel level = entry.value;
          return shortEntryButton(context,
              lessonIndex: index + 1, lessonName: level.category, onPress: () {
            GoRouter.of(context).goNamed('speechRanking', pathParameters: {
              'currentSpeechLevelReq': (index + 1).toString()
            });
          });
        }).toList(),
      ),
    );
  }
}
