import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:speechlab_dashboard/core/utils/color_util.dart';
import 'package:speechlab_dashboard/core/utils/number_util.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';

void displaySpeechResultsDialogue(BuildContext context,
    {required List<String> sentences,
    required List<dynamic> sentenceResults,
    required String profileImageURL,
    required String studentName}) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: CustomColors.orchid, width: 3)),
          backgroundColor: CustomColors.love,
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.55,
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
                            color: CustomColors.orchid,
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
                            color: CustomColors.orchid,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Average Pronounciation Accuracy: ${calculateAverage(sentenceResults).toStringAsFixed(2)}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: CustomColors.orchid,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      )),
                  Column(children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sentences.length,
                        itemBuilder: (context, index) {
                          final breakdownMap =
                              (sentenceResults[index] as Map<dynamic, dynamic>)
                                      .containsKey('breakdown')
                                  ? sentenceResults[index]['breakdown']
                                  : null;
                          return Padding(
                              padding: const EdgeInsets.all(6),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: CustomColors.orchid,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(9),
                                            child: Text(
                                                '${index + 1}. ${(sentences[index])}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: CustomColors.mercury,
                                                    fontSize: 15))),
                                      ],
                                    ),
                                    if (breakdownMap != null)
                                      vertical10PixHorizontal30Pix(
                                        context,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          height: 70,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Wrap(
                                                children: (breakdownMap
                                                        as List<dynamic>)
                                                    .map((word) {
                                              final wordData =
                                                  word as Map<String, dynamic>;
                                              return Text(
                                                '${wordData.keys.first} ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: wordData.values.first
                                                        ? Colors.green
                                                        : Colors.red),
                                              );
                                            }).toList()),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                              child: Text(
                                                'Pronounciation Accuracy: ${(sentenceResults[index]['similarity'] as double).toStringAsFixed(2)}%',
                                                style: const TextStyle(
                                                    color: CustomColors.orchid,
                                                    fontSize: 15),
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                              child: Text(
                                                'Confidence Level: ${(sentenceResults[index]['confidence'] as double).toStringAsFixed(2)}%',
                                                style: const TextStyle(
                                                    color: CustomColors.orchid,
                                                    fontSize: 15),
                                              )),
                                        ])
                                  ])));
                        })
                  ]),
                  const Gap(50),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('\tCLOSE\t')),
                ]),
              ))));
}
