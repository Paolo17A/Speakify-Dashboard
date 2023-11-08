import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/models/speech_model.dart';
import 'package:speechlab_dashboard/utils/student_speech_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';

import '../utils/color_util.dart';
import '../utils/firebase_util.dart';
import '../utils/number_util.dart';
import '../widgets/custom_text_widgets.dart';
import '../widgets/left_navigator_widget.dart';

class SelectedSpeechLabScreen extends StatefulWidget {
  final String currentSpeechLevelReq;
  const SelectedSpeechLabScreen(
      {super.key, required this.currentSpeechLevelReq});

  @override
  State<SelectedSpeechLabScreen> createState() =>
      _SelectedSpeechLabScreenState();
}

class _SelectedSpeechLabScreenState extends State<SelectedSpeechLabScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;
  List<DocumentSnapshot> _userDocs = [];

  late int currentSpeechLevelReq;
  late SpeechModel selectedLevel;

  @override
  void initState() {
    super.initState();
    currentSpeechLevelReq = int.parse(widget.currentSpeechLevelReq);
    selectedLevel = getSpeeechByIndex(currentSpeechLevelReq)!;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _isAdmin = await isAdmin();
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

      if (!_isAdmin) {
        final instructor = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        final instructorData = instructor.data() as Map<dynamic, dynamic>;
        List<dynamic> handledSections = instructorData['handledSections'];
        _userDocs = _userDocs.where((student) {
          final studentData = student.data() as Map<dynamic, dynamic>;
          return handledSections.contains(studentData['section']);
        }).toList();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting eligible students: $error')));
    }
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
                  SingleChildScrollView(
                    child: all8Pix(Column(
                      children: [
                        _selectedSpeechLabHeader(),
                        loveWineContainer(
                          height: MediaQuery.of(context).size.height * 0.85,
                          all20Pix(Column(
                            children: [
                              _labelHeaderRow(),
                              _speechLabEntriesContainer()
                            ],
                          )),
                        ),
                      ],
                    )),
                  )))
        ],
      ),
    );
  }

  Widget _selectedSpeechLabHeader() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(children: [
          AutoSizeText(selectedLevel.category, style: wineBoldStyle(size: 40)),
          const Divider(
            thickness: 5,
            color: CustomColors.darkWine,
          )
        ]));
  }

  Widget _labelHeaderRow() {
    return Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColors.orchid,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: AutoSizeText('ID Number',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mercury,
                      fontSize: 26))),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: AutoSizeText('Student Name',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mercury,
                      fontSize: 26))),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Center(
                child: AutoSizeText('Average Score',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mercury,
                        fontSize: 26)),
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          )
        ]));
  }

  Widget _speechLabEntriesContainer() {
    return _userDocs.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _userDocs.length,
            itemBuilder: (context, index) {
              final userData =
                  (_userDocs[index].data()! as Map<dynamic, dynamic>);
              final speechResults = userData['speechResults'];
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                      height: 85,
                      decoration: BoxDecoration(
                          color: CustomColors.mercury,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: AutoSizeText('ID Number',
                                        style: _studentEntryStyle())),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: AutoSizeText(
                                        '${(_userDocs[index].data()! as Map<dynamic, dynamic>)['firstName']} ${(_userDocs[index].data()! as Map<dynamic, dynamic>)['lastName']}',
                                        style: _studentEntryStyle())),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Center(
                                      child: AutoSizeText(
                                          '${calculateAverage(speechResults[widget.currentSpeechLevelReq.toString()]['confidenceScores']).toStringAsFixed(2)}%',
                                          style: _studentEntryStyle()),
                                    )),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: ElevatedButton(
                                    onPressed: () => displaySpeechResultsDialogue(
                                        context,
                                        sentences: speechCategories[
                                                currentSpeechLevelReq - 1]
                                            .sentences,
                                        sentenceResults: speechResults[widget
                                            .currentSpeechLevelReq
                                            .toString()]['confidenceScores'],
                                        profileImageURL:
                                            userData['profileImageURL'],
                                        studentName:
                                            '${userData['firstName']} ${userData['lastName']}'),
                                    child: const Icon(Icons.remove_red_eye),
                                  ),
                                )
                              ]))));
            })
        : Expanded(
            child: Center(
                child: Text('No student has done this lesson yet',
                    style: wineBoldStyle(size: 25))));
  }

  TextStyle _studentEntryStyle() {
    return const TextStyle(
        fontSize: 26, fontWeight: FontWeight.bold, color: CustomColors.orchid);
  }
}
