import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/error_message.dart';
import 'package:speechlab_dashboard/utils/personalized_widgets_util.dart';

import '../widgets/app_drawer_widget.dart';

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
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          'SPEECHLAB APP',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        drawer: appDrawer(context),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'DASHBOARD',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          Text(
                            '${DateTime.now()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            homeDashboardRowButton(
                                MediaQuery.of(context).size.width * 0.20,
                                MediaQuery.of(context).size.width * 0.15,
                                () {},
                                'DASHBOARD'),
                            homeDashboardRowButton(
                                MediaQuery.of(context).size.width * 0.20,
                                MediaQuery.of(context).size.width * 0.15,
                                () {},
                                'SCORES'),
                            homeDashboardRowButton(
                                MediaQuery.of(context).size.width * 0.20,
                                MediaQuery.of(context).size.width * 0.15,
                                () {},
                                'ACTIVIES & QUIZZES'),
                            homeDashboardRowButton(
                                MediaQuery.of(context).size.width * 0.20,
                                MediaQuery.of(context).size.width * 0.15,
                                () {},
                                'RANKING')
                          ],
                        ))
                  ],
                )),
              ));
  }
}
