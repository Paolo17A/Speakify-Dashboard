import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/speechLabTextField.dart';

import '../widgets/left_navigator_widget.dart';

class EditLessonScreen extends StatefulWidget {
  final String lessonID;
  const EditLessonScreen({super.key, required this.lessonID});

  @override
  State<EditLessonScreen> createState() => _EditLessonScreenState();
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  bool _isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<dynamic> additionalResources = [];
  final List<TextEditingController> _fileNameControllers = [];
  final List<TextEditingController> _downloadLinkControllers = [];
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getLessonData();
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

  Future _getLessonData() async {
    if (_isInitialized) {
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final lesson = await FirebaseFirestore.instance
          .collection('lessons')
          .doc(widget.lessonID)
          .get();
      final lessonData = lesson.data()!;
      _titleController.text = lessonData['lessonTitle'];
      _contentController.text = lessonData['lessonContent'];

      //  Retrieve and handle additional resources
      additionalResources = lessonData['additionalResources'];
      for (int i = 0; i < additionalResources.length; i++) {
        Map<dynamic, dynamic> resourceEntry = additionalResources[i];
        _fileNameControllers.add(TextEditingController());
        _fileNameControllers[i].text = resourceEntry['fileName'];
        _downloadLinkControllers.add(TextEditingController());
        _downloadLinkControllers[i].text = resourceEntry['downloadLink'];
      }

      setState(() {
        _isLoading = false;
        _isInitialized = true;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting lesson data: $error')));
    }
  }

  void editCustomLesson() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
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

      List<Map<dynamic, dynamic>> additionalResources = [];
      for (int i = 0; i < _downloadLinkControllers.length; i++) {
        additionalResources.add({
          'fileName': _fileNameControllers[i].text.trim(),
          'downloadLink': _downloadLinkControllers[i].text.trim()
        });
      }
      await FirebaseFirestore.instance
          .collection('lessons')
          .doc(widget.lessonID)
          .update({
        'lessonTitle': _titleController.text.trim(),
        'lessonContent': _contentController.text.trim(),
        'additionalResources': additionalResources
      });

      final instructor = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<dynamic, dynamic> instructorData =
          instructor.data() as Map<dynamic, dynamic>;

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${instructorData['firstName']} ${instructorData['lastName']} edited this lesson: ${_titleController.text.trim()}.'
      });

      setState(() {
        _isLoading = false;
      });

      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Successfully edited custom lesson!')));
      goRouter.go('/lessons');
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error editing custom lesson: $error')));
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
            lefNavigator(context, 3, isAdmin: false),
            bodyWidgetWhiteBG(
                context,
                stackedLoadingContainer(context, _isLoading, [
                  SingleChildScrollView(
                      child: all20Pix(
                    Column(
                      children: [
                        _lessonTitle(),
                        _lessonContent(),
                        const SizedBox(height: 30),
                        _additionalResources(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: editCustomLesson,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.orchid),
                            child: const Text('SAVE CHANGES',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                  )),
                ])),
          ],
        ));
  }

  Widget _lessonTitle() {
    return Column(children: [
      const Row(
        children: [
          Text('Lesson Title', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      speechLabTextField(
          'Lesson Title', _titleController, TextInputType.text, null),
      const SizedBox(height: 25),
    ]);
  }

  Widget _lessonContent() {
    return Column(children: [
      const Row(
        children: [
          Text('Lesson Content', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      speechLabTextField(
          'Lesson Content', _contentController, TextInputType.multiline, null),
    ]);
  }

  Widget _additionalResources() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Additional Resources',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () {
                setState(() {
                  _fileNameControllers.add(TextEditingController());
                  _downloadLinkControllers.add(TextEditingController());
                });
              },
              child: const Text('ADD',
                  style: TextStyle(fontWeight: FontWeight.bold)))
        ],
      ),
      if (_downloadLinkControllers.isNotEmpty)
        ListView.builder(
            shrinkWrap: true,
            itemCount: _downloadLinkControllers.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(children: [
                      speechLabTextField('Name', _fileNameControllers[index],
                          TextInputType.text, null),
                      const SizedBox(height: 10),
                      speechLabTextField('URL', _downloadLinkControllers[index],
                          TextInputType.url, null),
                    ]),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                      height: 90,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _fileNameControllers.removeAt(index);
                            _downloadLinkControllers.removeAt(index);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.orchid),
                        child: Transform.scale(
                            scale: 2,
                            child: const Icon(Icons.delete_rounded,
                                color: Colors.white)),
                      ))
                ],
              );
            }),
    ]);
  }
}
