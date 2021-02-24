import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/2_TaskListPage/TaskListWidget.dart';
import 'package:vistima_00/pages/2_TaskListPage/TaskTable.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  CalendarController controller;
  ValueNotifier<String> text;
  ValueNotifier<String> selectText;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();

    controller = CalendarController(
        minYear: now.year,
        minYearMonth: now.month - 1,
        maxYear: now.year,
        maxYearMonth: now.month + 1,
        selectDateModel: DateModel.fromDateTime(now),
        showMode: CalendarConstants.MODE_SHOW_ONLY_WEEK);

    controller.addMonthChangeListener(
      (year, month) {
        text.value = "$year.$month";
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      selectText.value =
          "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}";
    });

    text = ValueNotifier("${DateTime.now().year}.${DateTime.now().month}");

    selectText =
        ValueNotifier("单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(18)),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ValueListenableBuilder(
                    valueListenable: text,
                    builder: (context, value, child) {
                      return Text(
                        text.value,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(25),
                            fontWeight: FontWeight.bold),
                      );
                    }),
                Expanded(child: Container()),
                IconButton(
                    splashColor: Colors.red,
                    highlightColor: Colors.red,
                    icon: Icon(Icons.event_note),
                    onPressed: () {
                      //!
                    }),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: CalendarViewWidget(
              verticalSpacing: 0,
              calendarController: controller,
              weekBarItemWidgetBuilder: () => CustomStyleWeekBarItem(),
              dayWidgetBuilder: (dayModel) {
                return CustomStyleDayWidget(
                  dateModel: dayModel,
                  selectedColor: vColorMap['icon'],
                );
              },
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          //*List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7)),
            child: taskList(),
          ),
        ],
      ),
    );
  }

  Widget taskList() {
    return Container(
      // color: Color(0xffF5F5F5),
      child: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: selectText,
              builder: (context, value, child) {
                return Consumer2<TasksNotifier, TagsNotifier>(
                    builder: (context, tasksNotifier, labelsNotifier, _) {
                  DateModel dateModel =
                      controller.calendarProvider.selectDateModel;
                  DateTime date =
                      DateTime(dateModel.year, dateModel.month, dateModel.day);
                  List<Task> tasks = tasksNotifier.tasksInDate(date);

                  return TaskTable(
                    tasks: tasks,
                  );
                });
              }),
        ],
      ),
    );
  }
}
