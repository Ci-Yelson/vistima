import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//自定义周视图
class CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = ["M", "T", "W", "T", "F", "S", "S"];

  @override
  Widget getWeekBarItem(int index) {
    return Container(
      color: Colors.transparent,
      // height: ScreenUtil().setHeight(15),
      child: Center(
        child: Text(
          weekList[index],
          style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(125)),
        ),
      ),
    );
  }
}

//自定义日视图
class CustomStyleDayWidget extends BaseCombineDayWidget {
  CustomStyleDayWidget({
    DateModel dateModel,
    this.selectedColor,
  }) : super(dateModel);

  final Color selectedColor;

  final TextStyle normalTextStyle = TextStyle(
      fontSize: ScreenUtil().setSp(17),
      // fontWeight: FontWeight.w700,
      color: Colors.black);

  final TextStyle selectTextStyle = TextStyle(
      fontSize: ScreenUtil().setSp(17),
      // fontWeight: FontWeight.w700,
      color: Colors.white);

  final TextStyle noIsCurrentMonthTextStyle = TextStyle(
      fontSize: ScreenUtil().setSp(17),
      // fontWeight: FontWeight.w700,
      color: Colors.grey);

  @override
  Widget getNormalWidget(DateModel dateModel) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setHeight(12)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dateModel.isCurrentDay
            ? Colors.grey.withAlpha(100)
            : Colors.transparent,
      ),
      child: Center(
        child: Text(
          dateModel.day.toString(),
          style: normalTextStyle,
        ),
      ),
    );
  }

  @override
  Widget getSelectedWidget(DateModel dateModel) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setHeight(12)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selectedColor,
      ),
      child: Center(
        child: Text(
          dateModel.day.toString(),
          style: selectTextStyle,
        ),
      ),
    );
  }
}
