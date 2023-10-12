import 'package:flutter/material.dart';

import 'date_time_widget.dart';

PreferredSizeWidget appBarTitle() {
  return AppBar(
      title: Row(
        children: [
          const SizedBox(width: 10),
          Image.asset('assets/images/speechlab_logo.png', scale: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child:
                Text('SPEAKIFY', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [DateTimeDisplay()],
          ))
        ],
      ),
      automaticallyImplyLeading: false);
}
