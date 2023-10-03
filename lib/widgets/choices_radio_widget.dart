import 'package:flutter/material.dart';

class ChoicesRadioWidget extends StatefulWidget {
  final bool willReset;
  final void Function(String?, bool) choiceSelectCallback;
  final List<String> choiceLetters;

  const ChoicesRadioWidget(
      {super.key,
      required this.willReset,
      required this.choiceSelectCallback,
      required this.choiceLetters});

  @override
  State<ChoicesRadioWidget> createState() => _ChoicesRadioWidgetState();
}

class _ChoicesRadioWidgetState extends State<ChoicesRadioWidget> {
  String? _choice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.willReset) {
      print('WE WILL RESET');
      _choice = null;
    } else {
      print('NO NEED TO RESET');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
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
                      groupValue: _choice,
                      onChanged: (String? value) {
                        setState(() {
                          _choice = value;
                          widget.choiceSelectCallback(_choice, false);
                        });
                      },
                      activeColor: const Color.fromARGB(255, 60, 19, 97),
                    ),
                  ),
                ),
              )
              .toList()),
    );
  }
}
