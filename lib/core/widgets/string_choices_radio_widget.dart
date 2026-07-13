import 'package:flutter/material.dart';

class StringChoicesRadioWidget extends StatefulWidget {
  final String? initialString;
  final void Function(String?) choiceSelectCallback;
  final List<String> choiceLetters;

  const StringChoicesRadioWidget(
      {super.key,
      required this.initialString,
      required this.choiceSelectCallback,
      required this.choiceLetters});

  @override
  State<StringChoicesRadioWidget> createState() => ChoicesRadioWidgetState();
}

class ChoicesRadioWidgetState extends State<StringChoicesRadioWidget> {
  String? _choice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _choice = widget.initialString;
    });
  }

  void resetChoice() {
    setState(() {
      _choice = null;
    });
  }

  void setChoice(String choice) {
    setState(() {
      _choice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20)),
      child: RadioGroup<String>(
        groupValue: _choice,
        onChanged: (String? value) {
          setState(() {
            _choice = value;
            widget.choiceSelectCallback(_choice);
          });
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.choiceLetters
                .map(
                  (thisChoice) => SizedBox(
                    width: 70,
                    child: ListTile(
                      title: Text(
                        thisChoice,
                        textAlign: TextAlign.center,
                      ),
                      leading: Radio<String>(
                        value: thisChoice,
                        activeColor: const Color.fromARGB(255, 60, 19, 97),
                      ),
                    ),
                  ),
                )
                .toList()),
      ),
    );
  }
}
