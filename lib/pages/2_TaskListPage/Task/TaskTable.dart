import 'package:animations/animations.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/2_TaskListPage/TaskDetailPage.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';
import 'package:vistima_00/widgets/TagWrap.dart';

class TaskTable extends StatelessWidget {
  final List<Task> tasks;
  final TasksNotifier tasksNotifier;
  final bool inChartView;

  const TaskTable(
      {Key key,
      this.tasks,
      @required this.tasksNotifier,
      this.inChartView = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //!
    return tasks.length > 0
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              // LogUtil.e(tasks[index].toMap(), tag: 'TaskTable');
              return Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                child: OpenContainer(
                    closedElevation: 0,
                    // openColor: Colors.transparent,
                    openElevation: 0,
                    closedBuilder: (_, __) {
                      return TaskCard(
                        task: tasks[index],
                        inChartView: inChartView,
                      );
                    },
                    openBuilder: (_, __) {
                      return TaskDetailPage(
                        task: tasks[index],
                        tasksNotifier: tasksNotifier,
                      );
                    }),
              );
            })
        : Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "什么都没有哦~",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(32),
                  color: Colors.grey.withAlpha(100),
                  // letterSpacing: 1.3,
                  fontFamily: textfont),
            ),
          );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    Key key,
    @required this.task,
    this.inChartView = false,
  }) : super(key: key);

  final Task task;
  final bool inChartView;

  @override
  Widget build(BuildContext context) {
    int timeCost = task.timeCost.inSeconds;

    return Container(
      height:
          inChartView ? ScreenUtil().setHeight(50) : ScreenUtil().setHeight(80),
      width: ScreenUtil().setWidth(360),
      // color: Colors.red,
      child: Row(
        children: [
          Container(
            // color: Colors.red,
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //*P1
                Container(
                  margin: inChartView
                      ? EdgeInsets.only(
                          bottom: ScreenUtil().setHeight(20),
                          left: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(3),
                        )
                      : EdgeInsets.only(
                          bottom: ScreenUtil().setHeight(40),
                          left: ScreenUtil().setWidth(20),
                          right: ScreenUtil().setWidth(6),
                        ),
                  child: Row(
                    children: [
                      //*圆点
                      ClipOval(
                          child: Container(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setHeight(10),
                        color: vColorMap['processing_todo'],
                      )),
                      SizedBox(
                        width: ScreenUtil().setWidth(5),
                      ),
                      inChartView
                          ? Container()
                          :
                          //*横线
                          Container(
                              alignment: Alignment.center,
                              height: ScreenUtil().setHeight(3),
                              width: ScreenUtil().setWidth(8),
                              color: Colors.grey,
                            ),
                    ],
                  ),
                ),
                //*P2
                inChartView
                    ? Container()
                    : Container(
                        // color: Colors.grey,
                        child: Column(
                          children: [
                            Text(
                              '${formatDate(task.startTime, [
                                HH,
                                ':',
                                nn,
                                ':',
                                ss
                              ])}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Zhanku Wenyi',
                                fontSize: ScreenUtil().setSp(12),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(7),
                            ),
                            Text(
                              '${formatDate(task.endTime, [
                                HH,
                                ':',
                                nn,
                                ':',
                                ss
                              ])}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Zhanku Wenyi',
                                fontSize: ScreenUtil().setSp(12),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          inChartView
              ? Container()
              : SizedBox(
                  width: ScreenUtil().setWidth(22),
                ),
          //*P3
          Container(
            alignment: Alignment.center,
            // color: Colors.lightGreen,
            width: inChartView
                ? ScreenUtil().setWidth(100)
                : ScreenUtil().setWidth(200),
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${task.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(20)),
                ),
                inChartView
                    ? Container()
                    : tagWrap(
                        tagIds: task.tagIds,
                        backGroundColor: vColorMap['icon']),
              ],
            ),
          ),
          //*P4
          Expanded(child: Container()),
          inChartView
              ? Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "${(timeCost ~/ 3600).toStringAsFixed(0)}",
                      style: TextStyle(
                          letterSpacing: 1.3,
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text:
                          ":${(timeCost % 3600 ~/ 600).toStringAsFixed(0)}${((timeCost % 600) ~/ 60).toStringAsFixed(0)}",
                      style: TextStyle(
                          letterSpacing: 1.3,
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text:
                          ":${(timeCost % 60 ~/ 10).toStringAsFixed(0)}${(timeCost % 10).toStringAsFixed(0)}",
                      style: TextStyle(
                          letterSpacing: 1.3,
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ])),
                )
              : Container(
                  // color: Colors.lightBlue,
                  width: ScreenUtil().setWidth(375 - 328),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/编辑.png',
                    width: ScreenUtil().setWidth(28),
                    height: ScreenUtil().setHeight(28),
                  ),
                )
        ],
      ),
    );
  }
}
