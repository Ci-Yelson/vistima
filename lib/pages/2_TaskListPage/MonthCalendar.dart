import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/pages/2_TaskListPage/TaskTable.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';

/// 自定义风格+单选
class MonthCalendar extends StatefulWidget {
  @override
  _MonthCalendarState createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  ValueNotifier<String> text;
  ValueNotifier<String> selectText;

  CalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = new CalendarController(
        selectDateModel: DateModel.fromDateTime(DateTime.now()));

    controller.addMonthChangeListener(
      (year, month) {
        text.value = "$year年$month月";
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      selectText.value =
          "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}";
    });

    text = new ValueNotifier("${DateTime.now().year}年${DateTime.now().month}月");

    selectText = new ValueNotifier(
        "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
              icon: Icon(
                Icons.clear,
                size: ScreenUtil().setSp(24),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ValueListenableBuilder(
                  valueListenable: text,
                  builder: (context, value, child) {
                    return new Text(
                      '${text.value}',
                      style: TextStyle(
                        fontFamily: 'Zhanku Wenyi',
                        letterSpacing: 3,
                      ),
                    );
                  }),
            ],
          ),
        ),
        body: Consumer2<TasksNotifier, TagsNotifier>(
            builder: (context, tasksNotifier, tagsNotifier, _) {
          return Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                CalendarViewWidget(
                    verticalSpacing: ScreenUtil().setHeight(4),
                    calendarController: controller,
                    weekBarItemWidgetBuilder: () {
                      return _CustomStyleWeekBarItem();
                    },
                    dayWidgetBuilder: (dateModel) {
                      return _CustomStyleDayWidget(dateModel);
                    }),
                ValueListenableBuilder(
                    valueListenable: selectText,
                    builder: (context, value, child) {
                      // !日历任务板
                      return TaskTable(
                        tasks: tasksNotifier.tasksInDate(DateModel.toDatetime(
                            controller.calendarProvider.selectDateModel)),
                        tasksNotifier: tasksNotifier,
                      );
                    }),
              ],
            ),
          );
        }));
  }
}

class _CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = ["一", "二", "三", "四", "五", "六", "日"];

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      child: new Center(
        child: new Text(weekList[index]),
      ),
    );
  }
}

class _CustomStyleDayWidget extends BaseCustomDayWidget {
  _CustomStyleDayWidget(
    DateModel dateModel,
  ) : super(dateModel);

  @override
  void drawNormal(DateModel dateModel, Canvas canvas, Size size) {
    if (!dateModel.isCurrentMonth) {
      return;
    }
    bool isWeekend = dateModel.isWeekend;
    bool isInRange = dateModel.isInRange;

    if (dateModel.isCurrentDay) {
      //绘制背景
      Paint backGroundPaint = new Paint()
        // ..color = Color(0xff69b0ae)
        ..color = Colors.grey.withAlpha(100)
        ..strokeWidth = 2;
      double padding = 8;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2),
          (size.width - padding) / 2, backGroundPaint);
    }

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(
              color: !isInRange
                  ? Colors.grey
                  : isWeekend
                      ? vColorMap['icon']
                      : Colors.black,
              fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(
              color: !isInRange
                  ? Colors.grey
                  : isWeekend
                      ? Color(0xff69b0ae)
                      : Colors.grey,
              fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }

  @override
  void drawSelected(DateModel dateModel, Canvas canvas, Size size) {
    if (!dateModel.isCurrentMonth) {
      return;
    }
    //绘制背景
    Paint backGroundPaint = new Paint()
      // ..color = Color(0xff69b0ae)
      ..color = vColorMap['icon']
      ..strokeWidth = 2;
    double padding = 8;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        (size.width - padding) / 2, backGroundPaint);

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(color: Colors.white, fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(color: Colors.white, fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }
}
