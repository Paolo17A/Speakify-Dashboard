import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/active_students_widget.dart';
import 'package:speechlab_dashboard/utils/personalized_widgets_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/date_time_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';
import 'package:speechlab_dashboard/widgets/recent_activities_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<DocumentSnapshot> activeStudents = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeHomeScreen();
  }

  void _initializeHomeScreen() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error initializing home screen: $error')));
    }
  }

  void getActiveStudents() async {}

  bool isTimeDifferenceLessThan12Hours(DateTime dateTime1, DateTime dateTime2) {
    Duration difference = dateTime2.difference(dateTime1);
    return difference.inHours.abs() < 12;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                lefNavigator(context, 0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(40),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'DASHBOARD',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      DateTimeDisplay()
                                    ])))),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              homeDashboardRowButton(
                                  MediaQuery.of(context).size.width * 0.15,
                                  MediaQuery.of(context).size.width * 0.10, () {
                                GoRouter.of(context).go('/scores');
                              }, 'SCORES'),
                              homeDashboardRowButton(
                                  MediaQuery.of(context).size.width * 0.15,
                                  MediaQuery.of(context).size.width * 0.10, () {
                                GoRouter.of(context).go('/quizzes');
                              }, 'QUIZZES'),
                              homeDashboardRowButton(
                                  MediaQuery.of(context).size.width * 0.15,
                                  MediaQuery.of(context).size.width * 0.10, () {
                                GoRouter.of(context).go('/ranking');
                              }, 'RANKING')
                            ])),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text('RECENT ACTIVITY',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const RecentActiviesWidget()
                  ]),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    color:
                        const Color.fromARGB(255, 74, 0, 49).withOpacity(0.75),
                    child: const ActiveStudentsWidget())
              ]));
  }
}
