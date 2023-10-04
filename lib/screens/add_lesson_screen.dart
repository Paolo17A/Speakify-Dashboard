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
  final List<TextEditingController> _fileNameControllers = [];
  final List<TextEditingController> _downloadLinkControllers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
    for (int i = 0; i < _fileNameControllers.length; i++) {
      _fileNameControllers[i].dispose();
      _downloadLinkControllers[i].dispose();
    }
  }

  void addNewCustomLesson() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Please fill up all fields')));
      return;
    }
    for (int i = 0; i < _downloadLinkControllers.length; i++) {
      if (_fileNameControllers[i].text.isEmpty ||
          _downloadLinkControllers[i].text.isEmpty) {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text(
                'Please fill up all additional resource fields or delete unused ones.')));
        return;
      } else if (!Uri.tryParse(_downloadLinkControllers[i].text.trim())!
          .hasAbsolutePath) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content:
                Text('The URL provided in resource #${i + 1} is invalid')));
        return;
      }
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final currentLessons =
          await FirebaseFirestore.instance.collection('lessons').get();
      int lessonCount = currentLessons.docs.length;
      String lessonID = 'lesson${lessonCount.toString().padLeft(3, '0')}';

      List<Map<dynamic, dynamic>> additionalResources = [];
      for (int i = 0; i < _downloadLinkControllers.length; i++) {
        additionalResources.add({
          'fileName': _fileNameControllers[i].text.trim(),
          'downloadLink': _downloadLinkControllers[i].text.trim()
        });
      }
      await FirebaseFirestore.instance.collection('lessons').doc(lessonID).set({
        'lessonTitle': _titleController.text.trim(),
        'lessonContent': _contentController.text.trim(),
        'additionalResources': additionalResources
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
              height: MediaQuery.of(context).size.height,
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
                            TextInputType.text, null),
                        const SizedBox(height: 25),
                        const Row(
                          children: [
                            Text('Lesson Content',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        speechLabTextField('Lesson Content', _contentController,
                            TextInputType.multiline, null),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Additional Resources',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _fileNameControllers
                                        .add(TextEditingController());
                                    _downloadLinkControllers
                                        .add(TextEditingController());
                                  });
                                },
                                child: const Text('ADD',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                          ],
                        ),
                        if (_downloadLinkControllers.isNotEmpty)
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: _downloadLinkControllers.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Text('Resource # ${index + 1}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ],
                                        ),
                                        speechLabTextField(
                                            'Name',
                                            _fileNameControllers[index],
                                            TextInputType.text,
                                            null),
                                        const SizedBox(height: 10),
                                        speechLabTextField(
                                            'URL',
                                            _downloadLinkControllers[index],
                                            TextInputType.url,
                                            null),
                                      ]),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _fileNameControllers
                                                  .removeAt(index);
                                              _downloadLinkControllers
                                                  .removeAt(index);
                                            });
                                          },
                                          child: const Icon(Icons.delete,
                                              color: Colors.white),
                                        ))
                                  ],
                                );
                              }),
                        const SizedBox(height: 20),
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
