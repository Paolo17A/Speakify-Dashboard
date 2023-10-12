import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/active_students_widget.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';
import 'package:speechlab_dashboard/widgets/recent_activities_widget.dart';

import '../utils/color_util.dart';
import '../widgets/custom_buttons_widget.dart';

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
        body: switchedLoadingContainer(
            _isLoading,
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              lefNavigator(context, 0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(children: [
                  _homeDashboardRowWidgets(),
                  const Divider(
                    thickness: 4,
                    color: Color.fromARGB(255, 60, 19, 97),
                  ),
                  _recentActivityWidget()
                ]),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  color: CustomColors.darkWine,
                  child: const ActiveStudentsWidget())
            ])));
  }

  Widget _homeDashboardRowWidgets() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          homeDashboardRowButton(MediaQuery.of(context).size.width * 0.15,
              MediaQuery.of(context).size.width * 0.10, () {
            GoRouter.of(context).go('/scores');
          }, 'SCORES'),
          homeDashboardRowButton(MediaQuery.of(context).size.width * 0.15,
              MediaQuery.of(context).size.width * 0.10, () {
            GoRouter.of(context).go('/quizzes');
          }, 'QUIZZES'),
          homeDashboardRowButton(MediaQuery.of(context).size.width * 0.15,
              MediaQuery.of(context).size.width * 0.10, () {
            GoRouter.of(context).go('/ranking');
          }, 'RANKING')
        ]));
  }

  Widget _recentActivityWidget() {
    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: Row(
          children: [headerText(text: 'RECENT ACTIVITIES')],
        ),
      ),
      const RecentActiviesWidget()
    ]);
  }
}
