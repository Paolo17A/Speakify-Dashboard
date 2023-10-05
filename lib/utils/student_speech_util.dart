import 'package:flutter/material.dart';

void displaySpeechResultsDialogue(
    BuildContext context,
    final List<String> sentences,
    final List<dynamic> sentenceResults,
    String profileImageURL,
    String studentName) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 60, 19, 97),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
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
                        'Average Pronounciation Accuracy: ${_calculateAverage(sentenceResults).toStringAsFixed(2)}%',
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
                            itemCount: sentences.length,
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
                                                '${index + 1}. ${(sentences[index])}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 15))),
                                        const SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  child: Text(
                                                    'Pronounciation Accuracy: ${(sentenceResults[index]['similarity'] as double).toStringAsFixed(2)}%',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  )),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  child: Text(
                                                    'Confidence Level: ${(sentenceResults[index]['confidence'] as double).toStringAsFixed(2)}%',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  )),
                                            ])
                                      ])));
                            }))
                  ])
                ]),
              ))));
}

double _calculateAverage(List<dynamic> selectedLevel) {
  double sum = 0;

  for (var value in selectedLevel) {
    sum += value['average'];
  }

  return sum / selectedLevel.length;
}
