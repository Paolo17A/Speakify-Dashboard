import 'package:flutter/material.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class DateTimeDisplay extends StatefulWidget {
  const DateTimeDisplay({super.key});

  @override
  DateTimeDisplayState createState() => DateTimeDisplayState();
}

class DateTimeDisplayState extends State<DateTimeDisplay> {
  late DateTime _currentDateTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    // Update the time every second (1000 milliseconds)
    _timer = Timer.periodic(const Duration(seconds: 1), _updateDateTime);
  }

  void _updateDateTime(Timer timer) {
    setState(() {
      _currentDateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when disposing of the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('dd MMM yyyy hh:mm:ss a').format(_currentDateTime),
      style: const TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
