import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/screens/edit_lesson_screen.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

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
        body: Row(
          children: [
            lefNavigator(context, 3),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: const Text('CUSTOM LESSONS',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 60, 19, 97),
                                        fontSize: 55,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: 50,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/addLesson');
                                    },
                                    child: const Text(
                                      'ADD NEW LESSON',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                              )
                            ],
                          ),
                        ),
                        customLessons.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      runSpacing:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      children: customLessons.map((lesson) {
                                        return SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => EditLessonScreen(
                                                            additionalResources:
                                                                (lesson.data() as Map<dynamic, dynamic>)[
                                                                    'additionalResources'],
                                                            lessonID: lesson.id,
                                                            lessonTitle: (lesson
                                                                        .data()
                                                                    as Map<dynamic, dynamic>)[
                                                                'lessonTitle'],
                                                            lessonContent:
                                                                (lesson.data() as Map<
                                                                    dynamic,
                                                                    dynamic>)['lessonContent'])));
                                              },
                                              child: Text(
                                                (lesson.data() as Map<dynamic,
                                                    dynamic>)['lessonTitle'],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        );
                                      }).toList(),
                                    )),
                              )
                            : const Expanded(
                                child: Center(
                                    child: Text(
                                  'NO CUSTOM LESSONS AVAILABLE',
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                )),
                              )
                      ],
                    ),
            )
          ],
        ));
  }
}
