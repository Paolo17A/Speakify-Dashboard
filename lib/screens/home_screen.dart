import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/error_message.dart';
import 'package:speechlab_dashboard/utils/personalized_widgets_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/date_time_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeHomeScreen();
  }

  void _initializeHomeScreen() {
    try {
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      displayError(
          context, 'Error Initializing Home Screen: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool willQuit = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      title: const Text('Confirm Quit'),
                      content: const Text('Are you sure you want to quit?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Quit'))
                      ]));
          return willQuit;
        },
        child: Scaffold(
            appBar: appBarTitle(),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        lefNavigator(context, 0),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: double.infinity,
                            color: Colors.white,
                            child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  Padding(
                                      padding: const EdgeInsets.all(40),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.deepPurple
                                                  .withOpacity(0.75),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'DASHBOARD',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30),
                                                    ),
                                                    DateTimeDisplay()
                                                  ])))),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            homeDashboardRowButton(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15, () {
                                              Navigator.pushNamed(
                                                  context, '/activeStudents');
                                            }, 'ACTIVE STUDENTS'),
                                            homeDashboardRowButton(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15, () {
                                              Navigator.pushNamed(
                                                  context, '/scores');
                                            }, 'SCORES'),
                                            homeDashboardRowButton(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15, () {
                                              Navigator.pushNamed(context,
                                                  '/activitiesAndQuizzes');
                                            }, 'ACTIVIES & QUIZZES'),
                                            homeDashboardRowButton(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15, () {
                                              Navigator.pushNamed(
                                                  context, '/ranking');
                                            }, 'RANKING')
                                          ]))
                                ])))
                      ])));
  }
}
