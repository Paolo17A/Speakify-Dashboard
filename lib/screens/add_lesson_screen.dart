import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/speechLabTextField.dart';

import '../widgets/left_navigator_widget.dart';

class AddLessonScreen extends StatefulWidget {
  const AddLessonScreen({super.key});

  @override
  State<AddLessonScreen> createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  bool _isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  void addNewCustomLesson() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Please fill up all fields')));
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      final currentLessons =
          await FirebaseFirestore.instance.collection('lessons').get();
      int lessonCount = currentLessons.docs.length;
      String lessonID = 'lesson${lessonCount.toString().padLeft(3, '0')}';

      await FirebaseFirestore.instance.collection('lessons').doc(lessonID).set({
        'lessonTitle': _titleController.text.trim(),
        'lessonContent': _contentController.text.trim()
      });

      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Successfully added new custom lesson!')));
      navigator.pop();
      navigator.pushReplacementNamed('/lessons');
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error adding new custom lesson: $error')));
      setState(() {
        _isLoading = false;
      });
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
              height: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text('Lesson Title',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        speechLabTextField('Lesson Title', _titleController,
                            TextInputType.text),
                        const SizedBox(height: 25),
                        const Row(
                          children: [
                            Text('Lesson Content',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        speechLabTextField('Lesson Content', _contentController,
                            TextInputType.multiline),
                        const SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: addNewCustomLesson,
                            child: const Text('CREATE NEW LESSON',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                  )),
                  if (_isLoading)
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(child: CircularProgressIndicator()))
                ],
              ),
            )
          ],
        ));
  }
}
