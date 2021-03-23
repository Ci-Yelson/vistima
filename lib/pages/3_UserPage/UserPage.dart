import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/2_TaskListPage/TaskTable.dart';
import 'package:vistima_00/pages/3_UserPage/BorderTextWidget.dart';
import 'package:vistima_00/pages/3_UserPage/charts/ChartNotifier.dart';
import 'package:vistima_00/pages/3_UserPage/charts/charts_widget.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';

class ShowLabelNotifier extends ChangeNotifier {
  int labelSelectIndex = 0;

  changeIndex(int n) {
    labelSelectIndex = n;
    notifyListeners();
  }
}

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage>
    with AutomaticKeepAliveClientMixin {
  List<Task> _tasks = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "数据报表",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(30),
              color: vColorMap['mainText'],
              // fontWeight: FontWeight.w600,
              letterSpacing: 1.3,
              fontFamily: textfont),
        ),
        centerTitle: true,
        // isBackCustom: SpUtil.getString(USER_BACKGROUND, defValue: null) != null,
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setHeight(12)),
        child: Container(
          alignment: Alignment.center,
          child: Container(
              padding: EdgeInsets.symmetric(
                  // vertical: ScreenUtil().setHeight(10),
                  ),
              // ! 饼状图表
              child: ChangeNotifierProvider<ChartNotifier>.value(
                value: ChartNotifier(),
                builder: (context, child) {
                  return Consumer3<TasksNotifier, TagsNotifier, ChartNotifier>(
                      builder: (context, tasksNotifier, tagsNotifier,
                          chartNotifier, _) {
                    return Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            BorderTitle(
                                borderWidth: ScreenUtil().setWidth(7),
                                child: selectDateTime(context,
                                    chartNotifier: chartNotifier,
                                    dateTime: chartNotifier.startTime,
                                    timeMark: 'startTime',
                                    textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 3.3,
                                    ))),
                            Expanded(child: Container()),
                            Container(
                              // alignment: Alignment.centerRight,
                              child: FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  color: vColorMap['icon'],
                                  onPressed: () {
                                    chartNotifier.changeIsUseExample();
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        '示例',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(16)),
                                      ),
                                      chartNotifier.isUseExample
                                          ? Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            )
                                          : Container()
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        // ! 图表
                        ChartsWidget(
                          isUseExample: chartNotifier.isUseExample,
                          tasksNotifier: tasksNotifier,
                          chartNotifier: chartNotifier,
                          chartType: ChartType.pie,
                          chartSzie: ScreenUtil().setWidth(230),
                          dateTime: chartNotifier.startTime,
                        ),

                        SizedBox(
                          height: ScreenUtil().setHeight(10),
                        ),
                        //*P2
                        ChangeNotifierProvider<ShowLabelNotifier>.value(
                            value: ShowLabelNotifier(),
                            child: Consumer<ShowLabelNotifier>(
                              builder: (context, showLabelNotifier, child) {
                                int index = showLabelNotifier.labelSelectIndex;
                                _tasks =
                                    tasksNotifier.tasksInDate(DateTime.now());

                                return Row(
                                  children: [
                                    BorderTitle(
                                        borderWidth: ScreenUtil().setWidth(7),
                                        child: Text(
                                          '今日排行',
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(16),
                                              letterSpacing: 1.3,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    Expanded(child: Container()),
                                    Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            showLabelNotifier.changeIndex(0);
                                            _tasks = tasksNotifier
                                                .tasksInDate(DateTime.now());
                                          },
                                          child: Container(
                                            width: ScreenUtil().setWidth(50),
                                            height: ScreenUtil().setHeight(28),
                                            decoration: BoxDecoration(
                                              // !
                                              color: index == 0
                                                  ? vColorMap['icon']
                                                  : Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      ScreenUtil()
                                                          .setHeight(14)),
                                                  bottomLeft: Radius.circular(
                                                      ScreenUtil()
                                                          .setHeight(14))),
                                              // shape: BoxShape.circle
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '今天',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(13),
                                                  color: index == 0
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showLabelNotifier.changeIndex(1);
                                            _tasks = tasksNotifier
                                                .tasksInWeek(DateTime.now());
                                          },
                                          child: Container(
                                            //!
                                            color: index == 1
                                                ? vColorMap['icon']
                                                : Colors.white,
                                            width: ScreenUtil().setWidth(50),
                                            height: ScreenUtil().setHeight(28),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '本周',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(13),
                                                  color: index == 1
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showLabelNotifier.changeIndex(2);
                                            _tasks = tasksNotifier
                                                .tasksInMonth(DateTime.now());
                                          },
                                          child: Container(
                                            width: ScreenUtil().setWidth(50),
                                            height: ScreenUtil().setHeight(28),
                                            decoration: BoxDecoration(
                                              //!
                                              color: index == 2
                                                  ? vColorMap['icon']
                                                  : Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      ScreenUtil()
                                                          .setHeight(14)),
                                                  bottomRight: Radius.circular(
                                                      ScreenUtil()
                                                          .setHeight(14))),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '本月',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(13),
                                                  color: index == 2
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            )),
                        //* 日/周/月
                        TaskTable(
                          tasks: _tasks,
                          tasksNotifier: tasksNotifier,
                          inChartView: true,
                        )
                      ],
                    );
                  });
                },
              )),
        ),
      ),
    );
  }

  Widget selectDateTime(
    BuildContext context, {
    ChartNotifier chartNotifier,
    DateTime dateTime,
    String timeMark,
    TextStyle textStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // SizedBox(
        //   width: ScreenUtil().setWidth(10.0),
        // ),
        InkWell(
          onTap: () => _selectDate(context, chartNotifier, dateTime, timeMark),
          child: Row(
            children: <Widget>[
              Text(
                "${formatDate(dateTime, [yyyy, "-", mm, "-", "dd"])}",
                style: textStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, ChartNotifier chartNotifier,
      DateTime dateTime, String timeMark) async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child);
      },
    );

    if (date == null) return;

    if (timeMark == 'startTime') {
      chartNotifier.changeStartTime(date);
    } else {
      chartNotifier.changeEndTime(date);
    }
    chartNotifier.initSelcted();
  }

  @override
  bool get wantKeepAlive => true;
}
