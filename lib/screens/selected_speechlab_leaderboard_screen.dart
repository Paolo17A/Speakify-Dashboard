import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/models/speech_model.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_miscellaneous_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../widgets/custom_buttons_widget.dart';
import '../widgets/custom_text_widgets.dart';

class SelectedSpeechlabLeaderboardScreen extends StatefulWidget {
  final String currentSpeechLevelReq;
  const SelectedSpeechlabLeaderboardScreen(
      {super.key, required this.currentSpeechLevelReq});

  @override
  State<SelectedSpeechlabLeaderboardScreen> createState() =>
      _SelectedSpeechlabLeaderboardScreenState();
}

class _SelectedSpeechlabLeaderboardScreenState
    extends State<SelectedSpeechlabLeaderboardScreen> {
  bool _isLoading = true;
  List<DocumentSnapshot> _userDocs = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllEligibleUsers();
  }

  void _getAllEligibleUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    _userDocs = querySnapshot.docs.where((userDoc) {
      final data = userDoc.data() as Map<dynamic, dynamic>;
      return data.containsKey('userType') &&
          data['userType'] == 'STUDENT' &&
          data.containsKey('speechLesson') &&
          data['speechLesson'] >= int.parse(widget.currentSpeechLevelReq) &&
          (data['speechResults'] as Map<dynamic, dynamic>)
              .containsKey(widget.currentSpeechLevelReq);
    }).toList();

    _userDocs.sort((a, b) {
      double lessonA = calculateAverage(
          (a.data() as Map<dynamic, dynamic>)['speechResults']
              [widget.currentSpeechLevelReq]['confidenceScores']);
      double lessonB = calculateAverage(
          (b.data() as Map<dynamic, dynamic>)['speechResults']
              [widget.currentSpeechLevelReq]['confidenceScores']);
      return lessonA.compareTo(lessonB);
    });

    _userDocs = _userDocs.reversed.toList();

    setState(() {
      _isLoading = false;
    });
  }

  double calculateAverage(List<dynamic> confidenceScores) {
    double sum = 0;

    for (var value in confidenceScores) {
      sum += value['average'];
    }

    return sum / confidenceScores.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle(),
      body: Row(
        children: [
          lefNavigator(context, 0),
          bodyWidgetWhiteBG(
              context,
              switchedLoadingContainer(
                  _isLoading,
                  all8Pix(Column(
                    children: [
                      _speechTitleHeader(),
                      loveWineContainer(
                          SingleChildScrollView(
                              child: Column(children: [
                            rankingHeaders(context),
                            _rankingsContainer()
                          ])),
                          height: MediaQuery.of(context).size.height * 0.75)
                    ],
                  ))))
        ],
      ),
    );
  }

  Widget _speechTitleHeader() {
    return Row(
      children: [
        backButton(context, onPress: () => GoRouter.of(context).go('/ranking')),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: AutoSizeText(
              getSpeeechByIndex(int.parse(widget.currentSpeechLevelReq))!
                  .category,
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
              return studentSpeechRankingEntry(context,
                  index: index,
                  currentSpeechLevelReq: widget.currentSpeechLevelReq,
                  studentData: studentData);
            })
        : _noStudentsAvailable();
  }

  Widget _noStudentsAvailable() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.15),
      child: Text(
          'NO STUDENT IN THIS SECTION HAS COMPLETED THIS SPEECHLAB LEVEL YET.',
          textAlign: TextAlign.center,
          style: wineBoldStyle(size: 30)),
    );
  }
}
