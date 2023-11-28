import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/utils/firebase_util.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

class ActiveStudentsWidget extends StatefulWidget {
  const ActiveStudentsWidget({super.key});

  @override
  State<ActiveStudentsWidget> createState() => _ActiveStudentsScreenWidget();
}

class _ActiveStudentsScreenWidget extends State<ActiveStudentsWidget> {
  bool _isLoading = true;
  bool _isAdmin = false;
  List<DocumentSnapshot> activeStudents = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _isAdmin = await isAdmin();
    getActiveStudents();
  }

  void getActiveStudents() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final students = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isNull: false)
          .where('userType', isEqualTo: 'STUDENT')
          .get();
      activeStudents = students.docs.where((student) {
        return student.data().containsKey('lastLoginTime') &&
            isTimeDifferenceLessThan12Hours(
                (student.data()['lastLoginTime'] as Timestamp).toDate(),
                DateTime.now());
      }).toList();

      if (!_isAdmin) {
        final instructor = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        final instructorData = instructor.data() as Map<dynamic, dynamic>;
        List<dynamic> handledSections = instructorData['handledSections'];
        activeStudents = activeStudents.where((student) {
          final studentData = student.data() as Map<dynamic, dynamic>;
          return handledSections.contains(studentData['section']);
        }).toList();
      }

      // Sort the activeStudents based on lastLoginTime (most active to least active)
      activeStudents.sort((a, b) {
        DateTime timeA =
            ((a.data() as Map<dynamic, dynamic>)['lastLoginTime'] as Timestamp)
                .toDate();
        DateTime timeB =
            ((b.data() as Map<dynamic, dynamic>)['lastLoginTime'] as Timestamp)
                .toDate();
        return timeB.compareTo(timeA); // Compare in descending order
      });
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting active students: $error')));
    }
  }

  bool isTimeDifferenceLessThan12Hours(DateTime dateTime1, DateTime dateTime2) {
    // Calculate the difference between the two DateTimes
    Duration difference = dateTime2.difference(dateTime1);

    // Check if the absolute difference in hours is less than 12
    return difference.inHours.abs() < 12;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _activeStudentHeader(),
            switchedLoadingContainer(
                _isLoading,
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: activeStudents.isEmpty
                        ? _noActiveStudentsWidget()
                        : _activeStudentsDisplayWidget()))
          ],
        ));
  }

  Widget _activeStudentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const CircleAvatar(backgroundColor: Colors.green, radius: 5),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.16,
            child: AutoSizeText('ACTIVE STUDENTS',
                textAlign: TextAlign.center, style: wineBoldStyle(size: 25))),
      ],
    );
  }

  Widget _noActiveStudentsWidget() {
    return Center(
      child: Text('THERE ARE CURRENTLY NO ACTIVE STUDENTS',
          textAlign: TextAlign.center, style: wineBoldStyle(size: 25)),
    );
  }

  Widget _activeStudentsDisplayWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: ListView.builder(
          shrinkWrap: false,
          itemCount: activeStudents.length,
          itemBuilder: (context, index) {
            final studentData =
                activeStudents[index].data() as Map<dynamic, dynamic>;
            String imageURL = studentData['profileImageURL'];
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: roundedContainer(
                    //width: MediaQuery.of(context).size.width * 0.2,
                    color: CustomColors.mercury.withOpacity(0.3),
                    borderColor: CustomColors.orchid,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _profileImageWidget(imageURL),
                              _profileDataWidget(studentData)
                            ]))));
          }),
    );
  }

  Widget _profileImageWidget(String imageURL) {
    if (imageURL.isNotEmpty) {
      return CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          backgroundImage: NetworkImage(imageURL));
    } else {
      return CircleAvatar(
          backgroundColor: CustomColors.orchid.withOpacity(0.5),
          radius: 20,
          child: Icon(
            Icons.person,
            color: CustomColors.love,
          ));
    }
  }

  Widget _profileDataWidget(Map<dynamic, dynamic> studentData) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.1,
      child: Center(
        child: Column(children: [
          AutoSizeText('${studentData['firstName']} ${studentData['lastName']}',
              textAlign: TextAlign.center,
              minFontSize: 6,
              style: wineBoldStyle(size: 14)),
          AutoSizeText('Last Login:',
              textAlign: TextAlign.center,
              minFontSize: 6,
              style: wineBoldStyle(size: 10)),
          AutoSizeText(
              '${DateFormat('dd MMM yyyy hh:mm:ss a').format((studentData['lastLoginTime'] as Timestamp).toDate())}',
              minFontSize: 6,
              textAlign: TextAlign.center,
              style: wineBoldStyle(size: 10)),
        ]),
      ),
    );
  }
}
