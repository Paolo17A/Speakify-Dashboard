import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../utils/color_util.dart';
import '../widgets/custom_buttons_widget.dart';
import '../widgets/custom_text_widgets.dart';
import '../widgets/dropdown_widget.dart';

class EditSectionScreen extends StatefulWidget {
  final String sectionName;
  const EditSectionScreen({super.key, required this.sectionName});

  @override
  State<EditSectionScreen> createState() => _EditSectionScreenState();
}

class _EditSectionScreenState extends State<EditSectionScreen> {
  bool _isLoading = true;
  bool _isInitialized = false;

  //  LESSON VARIABLES
  List<DocumentSnapshot> allLessons = [];
  //List<dynamic> accessedLessons = [];
  Map<String, String> accessedLessonsMap = {};
  Map<String, String> allSelectableLessons = {}; //  {lessonID, lessonName}
  bool allLessonsAccessed = false;
  String _currentSelectedLesson = '';

  //QUIZ VARIABLES
  List<DocumentSnapshot> allQuizzes = [];
  List<dynamic> accessedQuizzes = [];
  List<dynamic> allSelectableQuizzes = [];
  bool allQuizzesAccessed = false;
  String _currentSelectedQuiz = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      getSectionDetails();
    }
  }

  //  FUTURES
  //============================================================================
  Future getSectionDetails() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      //  Get the section's data
      final section = await FirebaseFirestore.instance
          .collection('sections')
          .doc(widget.sectionName)
          .get();
      final sectionData = section.data() as Map<dynamic, dynamic>;
      final accessedLessons = sectionData['accessedLessons'];
      accessedQuizzes = sectionData['accessedQuizzes'];

      //  Hande the lessons
      final lessons =
          await FirebaseFirestore.instance.collection('lessons').get();
      allLessons = lessons.docs;
      allSelectableLessons.clear();
      for (var lesson in allLessons) {
        final lessonData = lesson.data() as Map<dynamic, dynamic>;

        if (accessedLessons.contains(lesson.id)) {
          accessedLessonsMap[lesson.id] = lessonData['lessonTitle'];
        } else {
          allSelectableLessons[lesson.id] = lessonData['lessonTitle'];
        }
      }
      if (allLessons.length == accessedLessons.length) {
        allLessonsAccessed = true;
      } else {
        allLessonsAccessed = false;
      }

      //  Handle the quizzes
      final quizzes =
          await FirebaseFirestore.instance.collection('quizzes').get();
      allQuizzes = quizzes.docs;
      allSelectableQuizzes.clear();
      for (var quiz in allQuizzes) {
        if (!accessedQuizzes.contains(quiz.id)) {
          allSelectableQuizzes.add(quiz.id);
        }
      }
      if (allQuizzes.length == accessedQuizzes.length) {
        allQuizzesAccessed = true;
      } else {
        allQuizzesAccessed = false;
      }

      setState(() {
        _isLoading = false;
        _isInitialized = true;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting section details: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future grantAccessToLesson() async {
    if (_currentSelectedLesson.isEmpty) {
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('sections')
          .doc(widget.sectionName)
          .update({
        'accessedLessons': FieldValue.arrayUnion([_currentSelectedLesson])
      });

      final instructor = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final instructorData = instructor.data() as Map<dynamic, dynamic>;

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${instructorData['firstName']} ${instructorData['lastName']} granted access to lesson $_currentSelectedLesson to section ${widget.sectionName}'
      });
      setState(() {
        _isInitialized = false;
      });
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully added new lesson to section.')));
      getSectionDetails();
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text('Error adding this section to handled sections: $error')));
    }
  }

  Future removeAccessToLesson() async {
    if (_currentSelectedLesson.isEmpty) {
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('sections')
          .doc(widget.sectionName)
          .update({
        'accessedLessons': FieldValue.arrayRemove([_currentSelectedLesson])
      });

      final instructor = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final instructorData = instructor.data() as Map<dynamic, dynamic>;

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${instructorData['firstName']} ${instructorData['lastName']} removed access to lesson $_currentSelectedLesson to section ${widget.sectionName}'
      });
      setState(() {
        _isInitialized = false;
      });
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(
              'Successfully removed access to this lesson for this section.')));
      getSectionDetails();
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text('Error adding this section to handled sections: $error')));
    }
  }

  Future grantAccessToQuiz() async {
    if (_currentSelectedQuiz.isEmpty) {
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('sections')
          .doc(widget.sectionName)
          .update({
        'accessedQuizzes': FieldValue.arrayUnion([_currentSelectedQuiz])
      });

      final instructor = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final instructorData = instructor.data() as Map<dynamic, dynamic>;

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${instructorData['firstName']} ${instructorData['lastName']} granted access to quiz $_currentSelectedQuiz to section ${widget.sectionName}'
      });
      setState(() {
        _isInitialized = false;
      });
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully added new quiz to section.')));
      getSectionDetails();
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text('Error adding this section to handled sections: $error')));
    }
  }

  Future removeAccessToQuiz() async {
    if (_currentSelectedQuiz.isEmpty) {
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('sections')
          .doc(widget.sectionName)
          .update({
        'accessedQuizzes': FieldValue.arrayRemove([_currentSelectedQuiz])
      });

      final instructor = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final instructorData = instructor.data() as Map<dynamic, dynamic>;

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${instructorData['firstName']} ${instructorData['lastName']} removed access to quiz $_currentSelectedQuiz to section ${widget.sectionName}'
      });
      setState(() {
        _isInitialized = false;
      });
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(
              'Successfully removed access to this quiz for this section.')));
      getSectionDetails();
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text('Error adding this section to handled sections: $error')));
    }
  }

  //============================================================================
  void showAddLessonDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.love,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.wine, width: 3)),
              child: all20Pix(Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'SELECT A LESSON TO GRANT ACCESS',
                    style: wineBoldStyle(size: 35),
                  ),
                  dropdownWidget(_currentSelectedLesson, (selected) {
                    setState(() {
                      _currentSelectedLesson = allSelectableLessons.keys
                          .firstWhere(
                              (key) => allSelectableLessons[key] == selected!);
                      ;
                    });
                  }, allSelectableLessons.values.toList(),
                      _currentSelectedLesson, false),
                  ElevatedButton(
                      onPressed: () => grantAccessToLesson(),
                      child: all20Pix(Text('GRANT ACCESS TO THIS LESSON')))
                ],
              )),
            ),
          );
        });
  }

  void showRemoveLessonDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.love,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.wine, width: 3)),
              child: all20Pix(Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'SELECT A LESSON TO REMOVE',
                    style: wineBoldStyle(size: 35),
                  ),
                  dropdownWidget(_currentSelectedLesson, (selected) {
                    setState(() {
                      _currentSelectedLesson = accessedLessonsMap.keys
                          .firstWhere(
                              (key) => accessedLessonsMap[key] == selected!);
                    });
                  }, accessedLessonsMap.values.toList(), _currentSelectedLesson,
                      false),
                  ElevatedButton(
                      onPressed: () => removeAccessToLesson(),
                      child: all20Pix(Text('REMOVE THIS LESSON')))
                ],
              )),
            ),
          );
        });
  }

  void showAddQuizDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.love,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.wine, width: 3)),
              child: all20Pix(Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'SELECT A QUIZ TO GRANT ACCESS',
                    style: wineBoldStyle(size: 35),
                  ),
                  dropdownWidget(_currentSelectedQuiz, (selected) {
                    setState(() {
                      _currentSelectedQuiz = selected!;
                    });
                  }, List.from(allSelectableQuizzes), _currentSelectedQuiz,
                      false),
                  ElevatedButton(
                      onPressed: () => grantAccessToQuiz(),
                      child: all20Pix(Text('GRANT ACCESS TO THIS QUIZ')))
                ],
              )),
            ),
          );
        });
  }

  void showRemoveQuizDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.love,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.wine, width: 3)),
              child: all20Pix(Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'SELECT A QUIZ TO REMOVE',
                    style: wineBoldStyle(size: 35),
                  ),
                  dropdownWidget(_currentSelectedQuiz, (selected) {
                    setState(() {
                      _currentSelectedQuiz = selected!;
                    });
                  }, List.from(accessedQuizzes), _currentSelectedQuiz, false),
                  ElevatedButton(
                      onPressed: () => removeAccessToQuiz(),
                      child: all20Pix(Text('REMOVE THIS LESSON')))
                ],
              )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle(),
      body: Row(
        children: [
          lefNavigator(context, 2, isAdmin: false),
          bodyWidgetWhiteBG(
              context,
              stackedLoadingContainer(context, _isLoading, [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _selectedSectionHeader(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [_lessonsContainer(), _quizzesContainer()],
                      )
                    ],
                  ),
                )
              ]))
        ],
      ),
    );
  }

  Widget _selectedSectionHeader() {
    return all8Pix(
      Row(
        children: [
          backButton(context,
              onPress: () => GoRouter.of(context).go('/instructors/edit')),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(children: [
                AutoSizeText(widget.sectionName,
                    style: wineBoldStyle(size: 40)),
                const Divider(
                  thickness: 5,
                  color: CustomColors.darkWine,
                )
              ])),
        ],
      ),
    );
  }

  Widget _lessonsContainer() {
    return all8Pix(loveWineContainer(
        all20Pix(Column(
          children: [
            Text('ACCESSED LESSONS', style: wineBoldStyle(size: 35)),
            all20Pix(
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                if (!allLessonsAccessed)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          _currentSelectedLesson = '';
                          showAddLessonDialog();
                        },
                        child: Text('Add Section', style: whiteBoldStyle())),
                  ),
                if (accessedLessonsMap.isNotEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          _currentSelectedLesson = '';
                          showRemoveLessonDialog();
                        },
                        child: Text('Remove Section', style: whiteBoldStyle())),
                  )
              ]),
            ),
            accessedLessonsMap.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: accessedLessonsMap.length,
                    itemBuilder: (context, index) {
                      List<String> lessonIDs = accessedLessonsMap.keys.toList();
                      final lessonName = accessedLessonsMap[lessonIDs[index]];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: loveWineContainer(
                            all8Pix(Center(child: Text(lessonName!)))),
                      );
                    })
                : Expanded(
                    child: Text(
                    'This section has no accessed lessons yet.',
                    style: wineBoldStyle(),
                  ))
          ],
        )),
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.75));
  }

  Widget _quizzesContainer() {
    return all8Pix(loveWineContainer(
        all20Pix(Column(
          children: [
            Text('ACCESSED QUIZZES', style: wineBoldStyle(size: 35)),
            all20Pix(
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                if (!allQuizzesAccessed)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          _currentSelectedQuiz = '';
                          showAddQuizDialog();
                        },
                        child: Text('Add Quiz', style: whiteBoldStyle())),
                  ),
                if (accessedQuizzes.isNotEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          _currentSelectedQuiz = '';
                          showRemoveQuizDialog();
                        },
                        child: Text('Remove Quiz', style: whiteBoldStyle())),
                  )
              ]),
            ),
            accessedQuizzes.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: accessedQuizzes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: loveWineContainer(all8Pix(
                            Center(child: Text(accessedQuizzes[index])))),
                      );
                    })
                : Expanded(
                    child: Text(
                    'This section has no accessed lessons yet.',
                    style: wineBoldStyle(),
                  ))
          ],
        )),
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.75));
  }
}
