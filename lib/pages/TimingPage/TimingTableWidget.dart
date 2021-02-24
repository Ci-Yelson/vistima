import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/pages/TimingPage/TimingNotifier.dart';
import 'package:vistima_00/pages/TimingPage/clock/clock.dart';

class TimingTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimingNotifier>(builder: (context, timingNotifier, _) {
      int totalTime = timingNotifier.totalTime.toInt();
      return Container(
        height: ScreenUtil().setHeight(300),
        child: Stack(
          children: <Widget>[
            Center(
              child: Clock(
                isShowText: false,
                isTiming: true,
                seconds: totalTime % 60,
                size: Size(
                    ScreenUtil().setWidth(272), ScreenUtil().setWidth(272)),
                color: Colors.white,
              ),
            ),
            Center(
              child: timePiece(
                  totalTime: totalTime,
                  fontSize: ScreenUtil().setSp(36),
                  color: Colors.white,
                  fontFamily: 'Break',
                  showWay: 1),
            )
          ],
        ),
      );
    });
  }
}

Widget timePiece(
    {int totalTime,
    double fontSize,
    Color color,
    String fontFamily,
    int showWay = 0}) {
  return Text.rich(TextSpan(children: [
    showWay < 4
        ? TextSpan(
            text:
                "${(totalTime ~/ 36000).toStringAsFixed(0)}${((totalTime % 36000) ~/ 3600).toStringAsFixed(0)}",
            style: TextStyle(
                fontSize: fontSize,
                color: color,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold),
          )
        : TextSpan(),
    showWay < 3
        ? TextSpan(
            text:
                ":${(totalTime % 3600 ~/ 600).toStringAsFixed(0)}${((totalTime % 600) ~/ 60).toStringAsFixed(0)}",
            style: TextStyle(
                fontSize: fontSize,
                color: color,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold),
          )
        : TextSpan(),
    showWay < 2
        ? TextSpan(
            text:
                ":${(totalTime % 60 ~/ 10).toStringAsFixed(0)}${(totalTime % 10).toStringAsFixed(0)}",
            style: TextStyle(
                fontSize: fontSize,
                color: color,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold),
          )
        : TextSpan(),
    showWay < 1
        ? TextSpan(
            text:
                ":${(totalTime % 100 ~/ 10).toStringAsFixed(0)}${(totalTime % 10).toStringAsFixed(0)}",
            style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold),
          )
        : TextSpan(),
  ]));
}
