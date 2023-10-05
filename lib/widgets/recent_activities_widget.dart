import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentActiviesWidget extends StatefulWidget {
  const RecentActiviesWidget({super.key});

  @override
  State<RecentActiviesWidget> createState() => _RecentActiviesWidgetState();
}

class _RecentActiviesWidgetState extends State<RecentActiviesWidget> {
  bool _isLoading = true;
  List<DocumentSnapshot> recentActivities = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getRecentActivities();
  }

  void getRecentActivities() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final activities =
          await FirebaseFirestore.instance.collection('recentActivities').get();
      recentActivities = activities.docs;

      recentActivities.sort((a, b) {
        DateTime timeA =
            ((a.data() as Map<dynamic, dynamic>)['dateAdded'] as Timestamp)
                .toDate();
        DateTime timeB =
            ((b.data() as Map<dynamic, dynamic>)['dateAdded'] as Timestamp)
                .toDate();
        return timeB.compareTo(timeA); // Compare in descending order
      });
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting recent activities: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : recentActivities.isEmpty
                ? const Center(child: Text('NO RECENT ACTIVIES AVAILABLE'))
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: recentActivities.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 74, 0, 49)
                                              .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            DateFormat('dd MMM yyyy hh:mm:ss a')
                                                .format(((recentActivities[
                                                                        index]
                                                                    .data()
                                                                as Map<dynamic,
                                                                    dynamic>)[
                                                            'dateAdded']
                                                        as Timestamp)
                                                    .toDate()),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 15)),
                                        Text(
                                            (recentActivities[index].data()
                                                    as Map<dynamic, dynamic>)[
                                                'activityMessage'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 15))
                                      ],
                                    ),
                                  )),
                            );
                          }),
                    ),
                  ));
  }
}
