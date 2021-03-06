import 'package:animations/animations.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/TimingPage/TimingPage.dart';
import 'package:vistima_00/utils.dart';

// ignore: non_constant_identifier_names
Widget VFloatingActionButton(
    BuildContext context, int pageIndex, Todo todo, int startType) {
  // LogUtil.e("Build", tag: 'VFAB');
  // LogUtil.e(pageIndex, tag: 'VFAB');
  LogUtil.e(startType, tag: "startType");
  return OpenContainer(
      closedColor: Colors.transparent,
      closedElevation: 0,
      openColor: Colors.transparent,
      openElevation: 0,
      closedBuilder: (_, openContainer) {
        return startButton(context);
      },
      openBuilder: (context, _) {
        return TimingPage(
          todo: todo,
          startType: startType,
        );
      });
}

Widget startButton(BuildContext context) {
  return Container(
    height: ScreenUtil().setHeight(64),
    width: ScreenUtil().setHeight(64),
    // color: Colors.transparent,
    child: ClipOval(
      child: Container(
        //*阴影未作用
        decoration: BoxDecoration(color: vColorMap['icon'], boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 5,
            color: Colors.red,
          ),
        ]),
        padding: EdgeInsets.all(ScreenUtil().setHeight(7)),
        child: Row(
          children: [
            SizedBox(width: ScreenUtil().setHeight(10.0)),
            Image.asset(
              'assets/images/Start.png',
              color: Colors.white,
              height: ScreenUtil().setHeight(35),
              width: ScreenUtil().setHeight(35),
            )
          ],
        ),
      ),
    ),
  );
}
