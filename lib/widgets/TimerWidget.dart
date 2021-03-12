import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() {
    var state = _TimerWidgetState();
    state.startTiming();
    return state;
  }
}

class _TimerWidgetState extends State<TimerWidget> {
  var timeymd = formatDate(DateTime.now(), [mm, '-', dd, '-', DD]);
  var timehns = formatDate(DateTime.now(), [HH, ':', nn]);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 35),
      alignment: Alignment.centerLeft,
      // color: Colors.amber,
      child: Column(
        children: [
          Container(
            child: Text(
              "$timehns",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Zhanku Wenyi"),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "$timeymd",
              style: TextStyle(fontSize: 14, fontFamily: "Zhanku Wenyi"),
            ),
          ),
        ],
      ),
    );
  }

  startTiming() {
    Timer.periodic(Duration(milliseconds: 1000 * 60), (Timer t) {
      if (!mounted) {
        return;
      }
      setState(() {
        timeymd = formatDate(DateTime.now(), [mm, '-', dd, '-', DD]);
        timehns = formatDate(DateTime.now(), [HH, ':', nn]);
      });
    });
  }
}
