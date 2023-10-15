import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_miscellaneous_widgets.dart';
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
                  pageHeaderWithDivider(context, label: 'SECTIONS'),
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
                              pathParameters: {
                                'selectedSection': 'AB Broad 3A'
                              });
                        }, '3A - AB BROAD'),
                        homeDashboardRowButton(
                            MediaQuery.of(context).size.width * 0.25,
                            MediaQuery.of(context).size.width * 0.15, () {
                          GoRouter.of(context).goNamed('selectedSection',
                              pathParameters: {
                                'selectedSection': 'AB Broad 3B'
                              });
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
                              pathParameters: {
                                'selectedSection': 'AB Broad 4A'
                              });
                        }, '4A - AB BROAD'),
                        homeDashboardRowButton(
                            MediaQuery.of(context).size.width * 0.25,
                            MediaQuery.of(context).size.width * 0.15, () {
                          GoRouter.of(context).goNamed('selectedSection',
                              pathParameters: {
                                'selectedSection': 'AB Broad 4B'
                              });
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
