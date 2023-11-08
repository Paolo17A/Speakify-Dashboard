import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/firebase_util.dart';
import 'custom_container_widgets.dart';
import 'custom_padding_widgets.dart';

class SectionStudentsCountWidget extends StatefulWidget {
  const SectionStudentsCountWidget({super.key});

  @override
  State<SectionStudentsCountWidget> createState() =>
      _SectionStudentsCountWidgetState();
}

class _SectionStudentsCountWidgetState
    extends State<SectionStudentsCountWidget> {
  bool _isLoading = true;
  bool _isAdmin = false;
  List<DocumentSnapshot> accessedSections = [];
  List<SectionData> sectionDatas = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _isAdmin = await isAdmin();
    getAccessibleSections();
  }

  Future getAccessibleSections() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      //  Get all accessed sections
      QuerySnapshot sections;
      if (_isAdmin == true) {
        sections =
            await FirebaseFirestore.instance.collection('sections').get();
        accessedSections = sections.docs;
      } else {
        sections = await FirebaseFirestore.instance
            .collection('sections')
            .where('instructors',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .get();
        accessedSections = sections.docs;
      }
      if (accessedSections.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      sectionDatas.clear();
      for (var section in accessedSections) {
        final sectionData = section.data() as Map<dynamic, dynamic>;
        List<dynamic> students = sectionData['students'];
        sectionDatas.add(SectionData(section.id, students.length));
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting accessible sections: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return switchedLoadingContainer(
        _isLoading,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: loveWineContainer(
              all8Pix(accessedSections.isNotEmpty
                  ? SfCartesianChart(
                      isTransposed: true,
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                          minimum: 0,
                          interval: 5,
                          title: AxisTitle(
                              text: 'Enrolled Students',
                              textStyle: wineBoldStyle())),
                      title: ChartTitle(
                          text: 'Available Sections',
                          textStyle: wineBoldStyle(size: 25)),
                      series: <ColumnSeries<SectionData, String>>[
                          ColumnSeries<SectionData, String>(
                              color: CustomColors.wine,
                              dataSource: sectionDatas,
                              xValueMapper: (SectionData sectionData, _) =>
                                  sectionData.section,
                              yValueMapper: (SectionData sectionData, _) =>
                                  sectionData.students)
                        ])
                  : Center(
                      child: Text(
                        'You have no assigned sections',
                        style: blackBoldStyle(size: 30),
                      ),
                    )),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25),
        ));
  }
}

class SectionData {
  final String section;
  final int students;
  SectionData(this.section, this.students);
}
