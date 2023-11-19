import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/firebase_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_miscellaneous_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';
import '../widgets/custom_buttons_widget.dart';
import '../widgets/custom_text_widgets.dart';

class SelectedQuizLeaderboardScreen extends StatefulWidget {
  final String quizID;
  const SelectedQuizLeaderboardScreen({super.key, required this.quizID});

  @override
  State<SelectedQuizLeaderboardScreen> createState() =>
      _SelectedQuizLeaderboardScreenState();
}

class _SelectedQuizLeaderboardScreenState
    extends State<SelectedQuizLeaderboardScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;
  List<DocumentSnapshot> _userDocs = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!hasLoggedInUser()) {
      GoRouter.of(context).go('/');
      return;
    }
    _isAdmin = await isAdmin();
    _getAllEligibleUsers();
  }

  void _getAllEligibleUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    _userDocs = querySnapshot.docs.where((userDoc) {
      final data = userDoc.data() as Map<dynamic, dynamic>;
      bool isStudent =
          data.containsKey('userType') && data['userType'] == 'STUDENT';
      bool doneWithQuizzes = data.containsKey('customQuizResults') &&
          (data['customQuizResults'] as Map<dynamic, dynamic>)
              .containsKey(widget.quizID) &&
          (data['customQuizResults'][widget.quizID] as Map<dynamic, dynamic>)
                  .length ==
              3;
      return isStudent && doneWithQuizzes;
    }).toList();

    _userDocs.sort((a, b) {
      double lessonA = getAverageQuizScore((a.data()
          as Map<dynamic, dynamic>)['customQuizResults'][widget.quizID]);
      double lessonB = getAverageQuizScore((b.data()
          as Map<dynamic, dynamic>)['customQuizResults'][widget.quizID]);
      return lessonA.compareTo(lessonB);
    });

    _userDocs = _userDocs.reversed.toList();
    setState(() {
      _isLoading = false;
    });
  }

  double getAverageQuizScore(Map<dynamic, dynamic> quizCategory) {
    double totalScore = 0;
    double averageScore = 0;
    quizCategory.forEach((difficultyKey, difficultyValue) {
      totalScore += (difficultyValue as Map<dynamic, dynamic>)['score'];
    });
    averageScore = (totalScore) / quizCategory.length;
    return averageScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle(),
      body: Row(
        children: [
          lefNavigator(context, 0, isAdmin: _isAdmin),
          bodyWidgetWhiteBG(
              context,
              switchedLoadingContainer(
                  _isLoading,
                  all8Pix(Column(
                    children: [
                      _quizTitleHeader(),
                      loveWineContainer(
                          SingleChildScrollView(
                              child: Column(
                            children: [
                              rankingHeaders(context),
                              _rankingsContainer()
                            ],
                          )),
                          height: MediaQuery.of(context).size.height * 0.65)
                    ],
                  ))))
        ],
      ),
    );
  }

  Widget _quizTitleHeader() {
    return Row(
      children: [
        backButton(context, onPress: () => GoRouter.of(context).go('/ranking')),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: AutoSizeText(
              widget.quizID,
              style: wineBoldStyle(size: 40),
            )),
      ],
    );
  }

  Widget _rankingsContainer() {
    return _userDocs.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _userDocs.length,
            itemBuilder: (context, index) {
              final studentData =
                  _userDocs[index].data() as Map<dynamic, dynamic>;
              return studentQuizRankingEntry(context,
                  index: index,
                  quizTitle: widget.quizID,
                  studentData: studentData);
            })
        : _noStudentsAvailable();
  }

  Widget _noStudentsAvailable() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.15),
      child: Text(
          'NO STUDENT IN THIS SECTION HAS COMPLETED ALL THREE QUIZZES YET',
          textAlign: TextAlign.center,
          style: wineBoldStyle(size: 30)),
    );
  }
}
