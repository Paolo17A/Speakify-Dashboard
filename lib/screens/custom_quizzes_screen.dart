import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/screens/add_quiz_screen.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';

class CustomQuizzesScreen extends StatefulWidget {
  const CustomQuizzesScreen({super.key});

  @override
  State<CustomQuizzesScreen> createState() => _CustomQuizzesScreenState();
}

class _CustomQuizzesScreenState extends State<CustomQuizzesScreen> {
  bool _isLoading = false;
  List<DocumentSnapshot> customQuizzes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void getCustomQuizzes() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      setState(() {
        _isLoading = true;
      });

      final quizSnapshot =
          await FirebaseFirestore.instance.collection('quizzes').get();

      customQuizzes = quizSnapshot.docs;
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting custom quizzes: $error')));
    }
  }

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
                                child: const Text('CUSTOM QUIZZES',
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddQuizScreen(
                                                      isEditing: false)));
                                    },
                                    child: const Text(
                                      'CREATE NEW QUIZ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                              )
                            ],
                          ),
                        ),
                        customQuizzes.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  return ElevatedButton(
                                      onPressed: () {},
                                      child: Text('${index + 1}'));
                                },
                              )
                            : const Expanded(
                                child: Center(
                                    child: Text(
                                'NO CUSTOM QUIZZES AVAILABLE',
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              )))
                      ],
                    ))
        ]));
  }
}
