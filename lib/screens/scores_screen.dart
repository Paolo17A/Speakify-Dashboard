import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/models/speech_model.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../utils/firebase_util.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;
  bool _isInitialized = false;
  bool _viewingQuizScores = true;
  List<DocumentSnapshot> allCustomQuizzes = [];

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
    if (_isInitialized) {
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final customQuizzes = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('isArchived', isEqualTo: false)
          .get();
      allCustomQuizzes = customQuizzes.docs;
      setState(() {
        _isLoading = false;
        _isInitialized = true;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting custom quizzes: $error')));
    }
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
                  all8Pix(SingleChildScrollView(
                      child: Column(children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          backButton(context,
                              onPress: () => GoRouter.of(context).go('/home')),
                          Column(children: [
                            _scoresHeader(),
                            _scoreChoiceSelector(),
                          ])
                        ]),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: _viewingQuizScores
                            ? _quizzesWidget()
                            : _speechScoresWidget())
                  ])))))
        ]));
  }

  Widget _scoresHeader() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(children: [
          AutoSizeText('SCORING RESULTS', style: wineBoldStyle(size: 45)),
          const Divider(
            thickness: 5,
            color: CustomColors.orchid,
          )
        ]));
  }

  Widget _scoreChoiceSelector() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            scoreOptionButton(context,
                label: 'Lesson Quiz Performance',
                isSelected: _viewingQuizScores, onPress: () {
              setState(() => _viewingQuizScores = true);
            }),
            scoreOptionButton(context,
                label: 'SpeechLab Performance',
                isSelected: !_viewingQuizScores, onPress: () {
              setState(() => _viewingQuizScores = false);
            })
          ])),
    );
  }

  Widget _quizzesWidget() {
    return loveWineContainer(Column(
        children: allCustomQuizzes
            .map((customQuiz) => vertical10PixHorizontal30Pix(context,
                child:
                    longEntryButton(context, label: customQuiz.id, onPress: () {
                  GoRouter.of(context).goNamed('selectedQuiz',
                      pathParameters: {'quizTitle': customQuiz.id});
                })))
            .toList()));
  }

  Widget _speechScoresWidget() {
    return loveWineContainer(
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Wrap(
            spacing: MediaQuery.of(context).size.width * 0.02,
            runSpacing: MediaQuery.of(context).size.width * 0.01,
            children: speechCategories.asMap().entries.map((entry) {
              final int index = entry.key;
              final SpeechModel level = entry.value;
              return shortEntryButton(context,
                  lessonIndex: index + 1,
                  lessonName: level.category,
                  onPress: () => GoRouter.of(context)
                          .goNamed('selectedSpeechLab', pathParameters: {
                        'currentSpeechLevelReq': (index + 1).toString()
                      }));
            }).toList(),
          ),
        ),
      ),
    );
  }
}
