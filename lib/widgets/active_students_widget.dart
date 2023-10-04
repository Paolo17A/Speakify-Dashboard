import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 74, 0, 49).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text('ACTIVE STUDENTS',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: activeStudents.isEmpty
                        ? const Center(
                            child: Text(
                                'THERE ARE CURRENTLY NO ACTIVE STUDENTS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700)),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: activeStudents.length,
                                itemBuilder: (context, index) {
                                  Map<dynamic, dynamic> studentData =
                                      activeStudents[index].data()
                                          as Map<dynamic, dynamic>;
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 9),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 74, 0, 49)
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${studentData['firstName']} ${studentData['lastName']}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  'Last Login: ${DateFormat('dd MMM yyyy hh:mm:ss a').format((studentData['lastLoginTime'] as Timestamp).toDate())}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10))
                                            ],
                                          ),
                                        )),
                                  );
                                }),
                          ))
          ],
        ));
  }
}
