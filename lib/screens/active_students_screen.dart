import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

class ActiveStudentsScreen extends StatefulWidget {
  const ActiveStudentsScreen({super.key});

  @override
  State<ActiveStudentsScreen> createState() => _ActiveStudentsScreenState();
}

class _ActiveStudentsScreenState extends State<ActiveStudentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(children: [
          lefNavigator(context, 0),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              color: Colors.white,
              child: const SingleChildScrollView(
                child: Column(children: [Text('ACTIVE STUDENTS SCREEN')]),
              ))
        ]));
  }
}
