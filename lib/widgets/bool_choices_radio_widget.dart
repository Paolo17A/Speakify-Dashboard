import 'package:flutter/material.dart';

class BoolChoicesRadioWidget extends StatefulWidget {
  final bool? initialBool;
  final void Function(bool?) choiceSelectCallback;

  const BoolChoicesRadioWidget(
      {super.key,
      required this.initialBool,
      required this.choiceSelectCallback});

  @override
  State<BoolChoicesRadioWidget> createState() => BoolChoicesRadioWidgetState();
}

class BoolChoicesRadioWidgetState extends State<BoolChoicesRadioWidget> {
  bool? _choice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _choice = widget.initialBool;
    });
  }

  void ResetChoice() {
    setState(() {
      _choice = null;
    });
  }

  void SetChoice(bool choice) {
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
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 140,
              child: ListTile(
                title: const Text(
                  'True',
                  textAlign: TextAlign.center,
                ),
                leading: Radio<bool>(
                  value: true,
                  groupValue: _choice,
                  onChanged: (bool? value) {
                    setState(() {
                      _choice = value;
                      widget.choiceSelectCallback(_choice);
                    });
                  },
                  activeColor: const Color.fromARGB(255, 60, 19, 97),
                ),
              ),
            ),
            SizedBox(
              width: 140,
              child: ListTile(
                title: const Text(
                  'False',
                  textAlign: TextAlign.center,
                ),
                leading: Radio<bool>(
                  value: false,
                  groupValue: _choice,
                  onChanged: (bool? value) {
                    setState(() {
                      _choice = value;
                      widget.choiceSelectCallback(_choice);
                    });
                  },
                  activeColor: const Color.fromARGB(255, 60, 19, 97),
                ),
              ),
            ),
          ]),
    );
  }
}
