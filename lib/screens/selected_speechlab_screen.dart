import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/models/speech_model.dart';
import 'package:speechlab_dashboard/utils/student_speech_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';

import '../widgets/left_navigator_widget.dart';

class SelectedSpeechLabScreen extends StatefulWidget {
  final String currentSpeechLevelReq;
  final String selectedLevel;
  const SelectedSpeechLabScreen(
      {super.key,
      required this.currentSpeechLevelReq,
      required this.selectedLevel});

  @override
  State<SelectedSpeechLabScreen> createState() =>
      _SelectedSpeechLabScreenState();
}

class _SelectedSpeechLabScreenState extends State<SelectedSpeechLabScreen> {
  bool _isLoading = true;
  List<DocumentSnapshot> _userDocs = [];

  late int currentSpeechLevelReq;
  late SpeechModel selectedLevel;

  @override
  void initState() {
    super.initState();
    currentSpeechLevelReq = int.parse(widget.currentSpeechLevelReq);
    selectedLevel = SpeechModel.fromJson(jsonDecode(widget.selectedLevel));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getEligibleStudents();
  }

  void _getEligibleStudents() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      _userDocs = querySnapshot.docs.where((userDoc) {
        final data = userDoc.data() as Map<dynamic, dynamic>;
        return data.containsKey('userType') &&
            data['userType'] == 'STUDENT' &&
            data.containsKey('speechLesson') &&
            data['speechLesson'] >= currentSpeechLevelReq &&
            (data['speechResults'] as Map<dynamic, dynamic>)
                .containsKey(currentSpeechLevelReq.toString());
      }).toList();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text('Error getting eligible students: ${error.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle(),
      body: Row(
        children: [
          lefNavigator(context, 0),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              color: Colors.white,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(selectedLevel.category,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 60, 19, 97),
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold))),
                        _userDocs.isNotEmpty
                            ? Column(children: [
                                Container(
                                    color:
                                        const Color.fromARGB(255, 82, 48, 124),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: Text('Student Name',
                                                      style: _headerStyle())),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: Text('AVERAGE SCORE',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: _headerStyle())),
                                            ]))),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _userDocs.length,
                                    itemBuilder: (context, index) {
                                      Map<dynamic, dynamic> speechResults =
                                          (_userDocs[index].data()! as Map<
                                              dynamic,
                                              dynamic>)['speechResults'];
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Container(
                                              height: 85,
                                              color: const Color.fromARGB(
                                                  255, 103, 65, 150),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
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
                                                                0.3,
                                                            child: Text(
                                                                '${(_userDocs[index].data()! as Map<dynamic, dynamic>)['firstName']} ${(_userDocs[index].data()! as Map<dynamic, dynamic>)['lastName']}',
                                                                style:
                                                                    _studentEntryStyle())),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.3,
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                      'Average Score: ${calculateAverage(speechResults[widget.currentSpeechLevelReq.toString()]['confidenceScores']).toStringAsFixed(2)}%',
                                                                      style:
                                                                          _studentEntryStyle()),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: ElevatedButton(
                                                                        onPressed: () => displaySpeechResultsDialogue(
                                                                              context,
                                                                              speechCategories[currentSpeechLevelReq - 1].sentences,
                                                                              speechResults[widget.currentSpeechLevelReq.toString()]['confidenceScores'],
                                                                              (_userDocs[index].data()! as Map<dynamic, dynamic>)['profileImageURL'],
                                                                              '${(_userDocs[index].data()! as Map<dynamic, dynamic>)['firstName']} ${(_userDocs[index].data()! as Map<dynamic, dynamic>)['lastName']}',
                                                                            ),
                                                                        child: const Text('VIEW RESULTS', textAlign: TextAlign.center, style: TextStyle(letterSpacing: 2))),
                                                                  )
                                                                ]))
                                                      ]))));
                                    })
                              ])
                            : const Expanded(
                                child: Center(
                                    child: Text(
                                        'No student has done this lesson yet')))
                      ])),
                    )),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return const TextStyle(
        fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
  }

  TextStyle _studentEntryStyle() {
    return const TextStyle(fontSize: 20, color: Colors.white);
  }

  double calculateAverage(List<dynamic> selectedLevel) {
    double sum = 0;

    for (var value in selectedLevel) {
      sum += value['average'];
    }

    return sum / selectedLevel.length;
  }
}
