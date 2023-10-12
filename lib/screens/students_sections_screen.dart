import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../widgets/custom_buttons_widget.dart';

class StudentsSectionsScreen extends StatelessWidget {
  const StudentsSectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle(),
      body: Row(
        children: [
          lefNavigator(context, 1),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 75),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 82, 26, 131)
                              .withOpacity(0.75),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Row(children: [
                        Padding(
                          padding: EdgeInsets.all(13),
                          child: Text(
                            'SECTIONS',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        homeDashboardRowButton(
                            MediaQuery.of(context).size.width * 0.25,
                            MediaQuery.of(context).size.width * 0.15, () {
                          GoRouter.of(context).goNamed('selectedSection',
                              pathParameters: {'section': 'AB Broad 3A'});
                        }, '3A - AB BROAD'),
                        homeDashboardRowButton(
                            MediaQuery.of(context).size.width * 0.25,
                            MediaQuery.of(context).size.width * 0.15, () {
                          GoRouter.of(context).goNamed('selectedSection',
                              pathParameters: {'section': 'AB Broad 3B'});
                        }, '3B - AB BROAD'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        homeDashboardRowButton(
                            MediaQuery.of(context).size.width * 0.25,
                            MediaQuery.of(context).size.width * 0.15, () {
                          GoRouter.of(context).goNamed('selectedSection',
                              pathParameters: {'section': 'AB Broad 4A'});
                        }, '4A - AB BROAD'),
                        homeDashboardRowButton(
                            MediaQuery.of(context).size.width * 0.25,
                            MediaQuery.of(context).size.width * 0.15, () {
                          GoRouter.of(context).goNamed('selectedSection',
                              pathParameters: {'section': 'AB Broad 4B'});
                        }, '4B - AB BROAD'),
                      ],
                    ),
                  )
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
