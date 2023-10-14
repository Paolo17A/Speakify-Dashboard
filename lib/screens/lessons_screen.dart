import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../utils/color_util.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  bool _isLoading = true;
  List<DocumentSnapshot> customLessons = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllCustomLessons();
  }

  void getAllCustomLessons() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final allCustomLessons =
          await FirebaseFirestore.instance.collection('lessons').get();
      customLessons = allCustomLessons.docs;

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting custom lessons: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(children: [
          lefNavigator(context, 3),
          bodyWidgetWhiteBG(
              context,
              switchedLoadingContainer(
                  _isLoading,
                  SingleChildScrollView(
                      child: all8Pix(Column(children: [
                    _customLessonsHeader(),
                    loveWineContainer(Column(children: [
                      addEntryButton(context,
                          onPress: () =>
                              GoRouter.of(context).go('/lessons/addLesson')),
                      _customLessonContainer()
                    ]))
                  ])))))
        ]));
  }

  Widget _customLessonsHeader() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(children: [
          cambriaWineHeaderText(text: 'CUSTOM LESSONS'),
          const Divider(
            thickness: 5,
            color: CustomColors.darkWine,
          )
        ]));
  }

  Widget _customLessonContainer() {
    return customLessons.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
                    children: customLessons.map((lesson) {
                  final lessondata = lesson.data() as Map<dynamic, dynamic>;
                  return vertical10PixHorizontal30Pix(context,
                      child: lessonEntryWithActionsContainer(context,
                          label: lessondata['lessonTitle'], editFunction: () {
                        GoRouter.of(context).goNamed('editLesson',
                            pathParameters: {'lessonID': lesson.id});
                      }, deleteFunction: () {}));
                }).toList())),
          )
        : Expanded(
            child: Center(
                child: cambriaText(
                    text: 'NO CUSTOM LESSONS AVAILABLE',
                    textStyle: const TextStyle(
                        color: CustomColors.plum,
                        fontSize: 40,
                        fontWeight: FontWeight.bold))),
          );
  }
}
