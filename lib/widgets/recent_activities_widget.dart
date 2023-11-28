import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';

import 'custom_text_widgets.dart';

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
        child: switchedLoadingContainer(
            _isLoading,
            loveWineContainer(
                Column(children: [
                  _recentActiviesHeader(),
                  _recentActivitiesContainer()
                ]),
                height: MediaQuery.of(context).size.height * 0.4)));
  }

  Widget _recentActiviesHeader() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: Row(
          children: [headerText(text: 'RECENT ACTIVITIES')],
        ),
      ),
    );
  }

  Widget _recentActivitiesContainer() {
    return recentActivities.isEmpty
        ? const Center(child: Text('NO RECENT ACTIVIES AVAILABLE'))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.33,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: recentActivities.length,
                  itemBuilder: (context, index) {
                    return _recentActivityEntry(index);
                  }),
            ),
          );
  }

  Widget _recentActivityEntry(int index) {
    final activityData =
        recentActivities[index].data() as Map<dynamic, dynamic>;
    String formattedDateTime = DateFormat('dd MMM yyyy hh:mm:ss a')
        .format((activityData['dateAdded'] as Timestamp).toDate());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
          height: 70,
          decoration: BoxDecoration(
              color: CustomColors.orchid.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedDateTime, style: whiteBoldStyle(size: 15)),
                const SizedBox(height: 5),
                Text(activityData['activityMessage'],
                    style: whiteBoldStyle(size: 12))
              ],
            ),
          )),
    );
  }
}
