import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vistima_00/utils.dart';

class BorderTitle extends StatelessWidget {
  final borderWidth;
  final Widget child;

  BorderTitle({this.borderWidth, this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
          width: borderWidth,
          style: BorderStyle.solid,
          color: vColorMap['icon'],
        ))),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().setWidth(12),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
