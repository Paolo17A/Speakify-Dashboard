import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

class ActiveStudentsWidget extends StatefulWidget {
  const ActiveStudentsWidget({super.key});

  @override
  State<ActiveStudentsWidget> createState() => _ActiveStudentsScreenWidget();
}

class _ActiveStudentsScreenWidget extends State<ActiveStudentsWidget> {
  bool _isLoading = true;
  List<DocumentSnapshot> activeStudents = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        cambriaText(
            text: 'ACTIVE STUDENTS',
            textStyle: const TextStyle(
                color: CustomColors.orchid,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _noActiveStudentsWidget() {
    return Center(
      child: Text('THERE ARE CURRENTLY NO ACTIVE STUDENTS',
          textAlign: TextAlign.center, style: whiteBoldStyle(size: 25)),
    );
  }

  Widget _activeStudentsDisplayWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: activeStudents.length,
            itemBuilder: (context, index) {
              final studentData =
                  activeStudents[index].data() as Map<dynamic, dynamic>;
              String imageURL = studentData['profileImageURL'];
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: roundedContainer(
                      width: MediaQuery.of(context).size.width * 0.18,
                      color: CustomColors.amethyst.withOpacity(0.3),
                      borderColor: CustomColors.lilac,
                      child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _profileImageWidget(imageURL),
                                _profileDataWidget(studentData)
                              ]))));
            }));
  }

  Widget _profileImageWidget(String imageURL) {
    if (imageURL.isNotEmpty) {
      return CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          backgroundImage: NetworkImage(imageURL));
    } else {
      return const CircleAvatar(
          backgroundColor: CustomColors.amethyst,
          radius: 20,
          child: Icon(
            Icons.person,
            color: CustomColors.love,
          ));
    }
  }

  Widget _profileDataWidget(Map<dynamic, dynamic> studentData) {
    return Column(children: [
      cambriaText(
          text: '${studentData['firstName']} ${studentData['lastName']}',
          textStyle: const TextStyle(
              color: CustomColors.orchid, fontWeight: FontWeight.bold)),
      cambriaText(
          text:
              'Last Login: ${DateFormat('dd MMM yyyy hh:mm:ss a').format((studentData['lastLoginTime'] as Timestamp).toDate())}',
          textStyle: const TextStyle(color: CustomColors.orchid, fontSize: 10))
    ]);
  }
}
