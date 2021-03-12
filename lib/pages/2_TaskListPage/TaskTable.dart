import 'package:animations/animations.dart';
import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/2_TaskListPage/TaskDetailPage.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/widgets/TagWrap.dart';

class TaskTable extends StatelessWidget {
  final List<Task> tasks;

  const TaskTable({Key key, this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                  return TaskCard(task: tasks[index]);
                },
                openBuilder: (_, __) {
                  return TaskDetailPage(
                    task: tasks[index],
                  );
                }),
          );
        });
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    Key key,
    @required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(80),
      width: ScreenUtil().setWidth(360),
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
                  margin: EdgeInsets.only(
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
                Container(
                  // color: Colors.grey,
                  child: Column(
                    children: [
                      Text(
                        '${formatDate(task.startTime, [HH, ':', nn, ':', ss])}',
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
                        '${formatDate(task.endTime, [HH, ':', nn, ':', ss])}',
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
          SizedBox(
            width: ScreenUtil().setWidth(22),
          ),
          //*P3
          Container(
            alignment: Alignment.center,
            // color: Colors.lightGreen,
            width: ScreenUtil().setWidth(200),
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
                tagWrap(
                    tagIds: task.tagIds, backGroundColor: vColorMap['icon']),
              ],
            ),
          ),
          //*P4
          Expanded(child: Container()),
          Container(
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
