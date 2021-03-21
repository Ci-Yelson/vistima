import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/todoViewModel.dart';

class SetTodoTypeNotifier extends ChangeNotifier {
  final Todo todo;

  int type = 0;

  SetTodoTypeNotifier(this.todo);

  void changeType(int n) {
    type = n;
    todo.type = type;
    notifyListeners();
  }
}

class SetTodoTypeWidget extends StatefulWidget {
  final Todo todo;

  const SetTodoTypeWidget({Key key, @required this.todo}) : super(key: key);

  @override
  _SetTodoTypeWidgetState createState() => _SetTodoTypeWidgetState();
}

class _SetTodoTypeWidgetState extends State<SetTodoTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: SetTodoTypeNotifier(widget.todo),
      child: Consumer<SetTodoTypeNotifier>(
        builder: (context, setTodoTypeNotifier, _) {
          int type = setTodoTypeNotifier.type;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*P1
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setTodoTypeNotifier.changeType(0);
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setHeight(24),
                      decoration: BoxDecoration(
                        // !
                        color: type == 0
                            ? vColorMap['icon']
                            : Colors.grey.withAlpha(50),
                        borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(ScreenUtil().setHeight(14)),
                            bottomLeft:
                                Radius.circular(ScreenUtil().setHeight(14))),
                        // shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Todo',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: type == 0 ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setTodoTypeNotifier.changeType(1);
                    },
                    child: Container(
                      //!
                      color: type == 1
                          ? vColorMap['icon']
                          : Colors.grey.withAlpha(50),
                      width: ScreenUtil().setWidth(70),
                      height: ScreenUtil().setHeight(24),
                      alignment: Alignment.center,
                      child: Text(
                        'Processing',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: type == 1 ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setTodoTypeNotifier.changeType(2);
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setHeight(24),
                      decoration: BoxDecoration(
                        //!
                        color: type == 2
                            ? vColorMap['icon']
                            : Colors.grey.withAlpha(50),
                        borderRadius: BorderRadius.only(
                            topRight:
                                Radius.circular(ScreenUtil().setHeight(14)),
                            bottomRight:
                                Radius.circular(ScreenUtil().setHeight(14))),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Done',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: type == 2 ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(6)),
              //*P2
              type == 0 || type == 1
                  ? Container(
                      // child: Text("编辑开始时间"),
                      child: _timeShower(
                          todo: widget.todo,
                          setTodoTypeNotifier: setTodoTypeNotifier),
                    )
                  : Container(
                      // child: Text("编辑开始和结束时间"),
                      child: _timeShower(
                          todo: widget.todo,
                          setTodoTypeNotifier: setTodoTypeNotifier),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _timeShower(
      {@required SetTodoTypeNotifier setTodoTypeNotifier, Todo todo}) {
    DateTime _startTime = todo.startTime ?? DateTime.now();
    DateTime _endTime = todo.endTime ?? DateTime.now();
    int type = setTodoTypeNotifier.type;

    //日期选择器
    _datePicker({int type = 0}) {
      showDatePicker(
        context: context,
        initialDate: _startTime, //选中的日期
        firstDate: DateTime(1980), //日期选择器上可选择的最早日期
        lastDate: DateTime(2100), //日期选择器上可选择的最晚日期
      ).then((selectedValue) {
        setState(() {
          if (selectedValue != null) {
            //将选中的值传递出来
            type == 0 ? _startTime = selectedValue : _endTime = selectedValue;
            //*更新任务信息
            type == 0 ? todo.startTime = _startTime : todo.endTime = _endTime;
            // todosNotifier.update(todo.id, todo);
          }
        });
      });
    }

    //时间选择器
    _timePicker({int type = 0}) async {
      // 获取异步方法里面的值的第二种方式：async+await
      //await的作用是等待异步方法showDatePicker执行完毕之后获取返回值
      var result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startTime), //选中的时间
      );
      //将选中的值传递出来
      if (result != null) {
        type == 0
            ? _startTime = DateTime(_startTime.year, _startTime.month,
                _startTime.day, result.hour, result.minute)
            : _endTime = DateTime(_endTime.year, _endTime.month, _endTime.day,
                result.hour, result.minute);
        setState(() {
          //*更新任务信息
          type == 0 ? todo.startTime = _startTime : todo.endTime = _endTime;
          // todosNotifier.update(todo.id, todo);
        });
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              child: Text(
                "开始时间 - ",
                style: TextStyle(color: vColorMap['subText']),
              ),
            ),
            InkWell(
              onTap: () {
                _datePicker(type: 0);
              },
              child: Row(
                children: [
                  Text(
                    "${formatDate(_startTime, [yyyy, "-", mm, "-", "dd"])}",
                    style: TextStyle(color: vColorMap['subText']),
                  ),
                  Icon(Icons.arrow_drop_down, color: vColorMap['subText'])
                ],
              ),
            ),
            InkWell(
              onTap: () {
                _timePicker(type: 0);
              },
              child: Row(
                children: [
                  Text(
                    "${TimeOfDay.fromDateTime(_startTime).format(context)}",
                    style: TextStyle(color: vColorMap['subText']),
                  ),
                  Icon(Icons.arrow_drop_down, color: vColorMap['subText'])
                ],
              ),
            ),
          ],
        ),
        type == 2
            ? Row(
                children: [
                  Container(
                    child: Text(
                      "结束时间 - ",
                      style: TextStyle(color: vColorMap['subText']),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _datePicker(type: 1);
                    },
                    child: Row(
                      children: [
                        Text(
                          "${formatDate(_endTime, [yyyy, "-", mm, "-", "dd"])}",
                          style: TextStyle(color: vColorMap['subText']),
                        ),
                        Icon(Icons.arrow_drop_down, color: vColorMap['subText'])
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _timePicker(type: 1);
                    },
                    child: Row(
                      children: [
                        Text(
                          "${TimeOfDay.fromDateTime(_endTime).format(context)}",
                          style: TextStyle(color: vColorMap['subText']),
                        ),
                        Icon(Icons.arrow_drop_down, color: vColorMap['subText'])
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
