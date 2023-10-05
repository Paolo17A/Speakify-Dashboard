import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    getCustomQuizzes();
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

  void archiveQuiz(String quizTitle, bool currentValue) async {
    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizTitle)
        .update({'isArchived': !currentValue});
    final quizSnapshot =
        await FirebaseFirestore.instance.collection('quizzes').get();

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
          '${instructorData['firstName']} ${instructorData['lastName']} ${currentValue == false ? 'archived' : 'restored'} quiz $quizTitle.'
    });
    setState(() {
      customQuizzes = quizSnapshot.docs;
    });
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
                                      GoRouter.of(context)
                                          .go('/quizzes/addQuiz');
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
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: customQuizzes.length,
                                  itemBuilder: (context, index) {
                                    Map<dynamic, dynamic> quizData =
                                        customQuizzes[index].data()
                                            as Map<dynamic, dynamic>;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: 100,
                                          child: ElevatedButton(
                                              onPressed: () =>
                                                  GoRouter.of(context).go(
                                                      '/quizzes/editQuiz',
                                                      extra: {
                                                        'quizTitle':
                                                            customQuizzes[index]
                                                                .id,
                                                        'serializedQuizContent':
                                                            quizData[
                                                                'quizContent']
                                                      }),
                                              child: Text(
                                                  customQuizzes[index].id,
                                                  style: const TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                          height: 100,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                archiveQuiz(
                                                    customQuizzes[index].id,
                                                    quizData['isArchived']);
                                              },
                                              child: Text(quizData['isArchived']
                                                  ? 'RESTORE'
                                                  : 'ARCHIVE')),
                                        )
                                      ],
                                    );
                                  },
                                ),
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
