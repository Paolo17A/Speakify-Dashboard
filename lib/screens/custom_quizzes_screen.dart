import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/firebase_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../utils/color_util.dart';
import '../widgets/custom_buttons_widget.dart';

class CustomQuizzesScreen extends StatefulWidget {
  const CustomQuizzesScreen({super.key});

  @override
  State<CustomQuizzesScreen> createState() => _CustomQuizzesScreenState();
}

class _CustomQuizzesScreenState extends State<CustomQuizzesScreen> {
  bool _isLoading = false;
  bool _isAdmin = false;
  List<DocumentSnapshot> customQuizzes = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!hasLoggedInUser()) {
      GoRouter.of(context).go('/');
      return;
    }
    _isAdmin = await isAdmin();
    getCustomQuizzes();
  }

  void getCustomQuizzes() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      setState(() {
        _isLoading = true;
      });

      final quizSnapshot =
          await FirebaseFirestore.instance.collection('quizzes').get();

      customQuizzes = quizSnapshot.docs;
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting custom quizzes: $error')));
    }
  }

  void archiveQuiz(String quizTitle, bool currentValue) async {
    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizTitle)
        .update({'isArchived': !currentValue});
    final quizSnapshot =
        await FirebaseFirestore.instance.collection('quizzes').get();

    final instructor = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<dynamic, dynamic> instructorData =
        instructor.data() as Map<dynamic, dynamic>;

    await FirebaseFirestore.instance
        .collection('recentActivities')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'dateAdded': DateTime.now(),
      'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
      'activityMessage':
          '${instructorData['firstName']} ${instructorData['lastName']} ${currentValue == false ? 'archived' : 'restored'} quiz $quizTitle.'
    });
    setState(() {
      customQuizzes = quizSnapshot.docs;
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
                  SingleChildScrollView(
                    child: all8Pix(Column(children: [
                      _customQuizzesHeader(),
                      loveWineContainer(Column(children: [
                        if (!_isAdmin)
                          addEntryButton(context,
                              label: 'ADD NEW QUIZ  ',
                              onPress: () =>
                                  GoRouter.of(context).go('/quizzes/addQuiz')),
                        _customQuizzesContainer()
                      ]))
                    ])),
                  )))
        ]));
  }

  Widget _customQuizzesHeader() {
    return Row(
      children: [
        backButton(context, onPress: () => GoRouter.of(context).go('/home')),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(children: [
              AutoSizeText('CUSTOM QUIZZES', style: wineBoldStyle(size: 40)),
              const Divider(
                thickness: 5,
                color: CustomColors.darkWine,
              )
            ])),
      ],
    );
  }

  Widget _customQuizzesContainer() {
    return customQuizzes.isNotEmpty
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: _isAdmin
                ? MediaQuery.of(context).size.height * 0.75
                : MediaQuery.of(context).size.height * 0.65,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: customQuizzes.length,
              itemBuilder: (context, index) {
                final quizData =
                    customQuizzes[index].data() as Map<dynamic, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_isAdmin) {
                                return;
                              }
                              GoRouter.of(context).goNamed('editQuiz',
                                  pathParameters: {
                                    'quizTitle': customQuizzes[index].id
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                                side:
                                    const BorderSide(color: CustomColors.wine),
                                backgroundColor: CustomColors.mercury),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: AutoSizeText(customQuizzes[index].id,
                                        style: const TextStyle(
                                            color: CustomColors.orchid,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold))),
                              ],
                            )),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              archiveQuiz(customQuizzes[index].id,
                                  quizData['isArchived']);
                            },
                            style: ElevatedButton.styleFrom(
                                side:
                                    const BorderSide(color: CustomColors.wine),
                                backgroundColor: CustomColors.mercury),
                            child: AutoSizeText(
                                quizData['isArchived'] ? 'RESTORE' : 'ARCHIVE',
                                style: const TextStyle(
                                    color: CustomColors.orchid,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        : Center(
            child: Text(
            'NO CUSTOM QUIZZES AVAILABLE',
            style: TextStyle(
                color: CustomColors.wine,
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ));
  }
}
