import 'package:flutter/material.dart';

void displayQuizAnswersDialogue(
    String difficulty,
    BuildContext context,
    List<dynamic> quizQuestions,
    List<dynamic> userAnswers,
    String profileImageURL,
    String studentName,
    int score) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 60, 19, 97),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(children: [
                //  PROFILE IMAGE
                profileImageURL.isEmpty
                    ? const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Color.fromARGB(255, 53, 1, 36),
                        ))
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(profileImageURL, scale: 1)),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      studentName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Score: $score out of ${quizQuestions.length}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    )),
                Column(children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                          itemCount: quizQuestions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(6),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 44, 4, 31),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(children: [
                                      Padding(
                                          padding: const EdgeInsets.all(9),
                                          child: Text(
                                              '${index + 1}. ${(quizQuestions[index]['question'] as String)}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 15))),
                                      _answerWidget(context, difficulty,
                                          quizQuestions, userAnswers, index),
                                      const SizedBox(height: 10)
                                    ])));
                          }))
                ])
              ]))));
}

Widget _answerWidget(BuildContext context, String difficulty,
    List<dynamic> quizQuestions, List<dynamic> userAnswers, int index) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (difficulty == 'EASY')
            answerText(context,
                'Your Answer: ${userAnswers[index] as String}) ${quizQuestions[index]['options'][userAnswers[index] as String]}'),
          if (difficulty == 'AVERAGE')
            answerText(context, 'Your Answer: ${userAnswers[index] as bool}'),
          if (difficulty == 'DIFFICULT')
            answerText(context, 'Your Answer: ${userAnswers[index] as String}'),
          if (difficulty == 'EASY')
            answerText(context,
                'Correct Answer: ${quizQuestions[index]['answer'] as String}) ${quizQuestions[index]['options'][quizQuestions[index]['answer']] as String}'),
          if (difficulty == 'AVERAGE')
            answerText(context,
                'Correct Answer: ${quizQuestions[index]['answer'] as bool}'),
          if (difficulty == 'DIFFICULT')
            answerText(
                context, 'Accepted Answers: ${quizQuestions[index]['answer']}'),
        ]),
      ],
    ),
  );
}

Widget answerText(BuildContext context, String answer) {
  return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Text(
            answer,
            softWrap: true,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          )));
}
