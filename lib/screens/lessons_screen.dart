import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

import '../utils/color_util.dart';
import '../utils/firebase_util.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
import '../widgets/custom_text_widgets.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;
  List<DocumentSnapshot> customLessons = [];
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!hasLoggedInUser()) {
      GoRouter.of(context).go('/');
      return;
    }
    _isAdmin = await isAdmin();
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

  Future deleteLesson(String lessonUID) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      setState(() {
        _isLoading = true;
      });
      //Get all sections with access to this lesson
      final sections = await FirebaseFirestore.instance
          .collection('sections')
          .where('accessedLessons', arrayContains: lessonUID)
          .get();
      final sectionDocs = sections.docs;
      for (var doc in sectionDocs) {
        await FirebaseFirestore.instance
            .collection('sections')
            .doc(doc.id)
            .update({
          'accessedLessons': FieldValue.arrayRemove([lessonUID])
        });
      }
      await FirebaseFirestore.instance
          .collection('lessons')
          .doc(lessonUID)
          .delete();
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Successfully deleted this lesson.')));
      getAllCustomLessons();
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error deleting lesson: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(children: [
          lefNavigator(context, 3, isAdmin: _isAdmin),
          bodyWidgetWhiteBG(
              context,
              switchedLoadingContainer(
                  _isLoading,
                  SingleChildScrollView(
                      child: all8Pix(Column(children: [
                    _customLessonsHeader(),
                    loveWineContainer(Column(children: [
                      if (!_isAdmin)
                        addEntryButton(context,
                            label: 'ADD NEW LESSON',
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
          AutoSizeText('CUSTOM LESSONS', style: wineBoldStyle(size: 40)),
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
                height: _isAdmin
                    ? MediaQuery.of(context).size.height * 0.75
                    : MediaQuery.of(context).size.height * 0.65,
                child: SingleChildScrollView(
                  child: Column(
                      children: customLessons.map((lesson) {
                    final lessondata = lesson.data() as Map<dynamic, dynamic>;
                    return vertical10PixHorizontal30Pix(context,
                        child: lessonEntryWithActionsContainer(context,
                            label: lessondata['lessonTitle'],
                            editFunction: () {
                              GoRouter.of(context).goNamed('editLesson',
                                  pathParameters: {'lessonID': lesson.id});
                            },
                            deleteFunction: () => deleteLesson(lesson.id),
                            mayEditLesson: !_isAdmin));
                  }).toList()),
                )),
          )
        : SizedBox(
            height: _isAdmin
                ? MediaQuery.of(context).size.height * 0.75
                : MediaQuery.of(context).size.height * 0.65,
            child: Center(
                child: AutoSizeText('NO CUSTOM LESSONS AVAILABLE',
                    style: const TextStyle(
                        color: CustomColors.wine,
                        fontSize: 40,
                        fontWeight: FontWeight.bold))),
          );
  }
}
