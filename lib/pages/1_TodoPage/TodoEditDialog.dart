import 'package:circular_check_box/circular_check_box.dart';
import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/0_HomePage/TagEditDialog.dart';
import 'package:vistima_00/pages/0_HomePage/TagEditPage.dart';
import 'package:vistima_00/pages/1_TodoPage/AddTodoWidget.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';
import 'package:vistima_00/viewmodel/todoViewModel.dart';
import 'package:vistima_00/widgets/TagWrap.dart';
import 'package:vistima_00/widgets/VCheckBox.dart';

/**
 * ToddEidtDialog：支持编辑Todo的基本信息以及添加新Todo
 * 使用时需传入一个Todo实例，
 * bool参数addTodo设置为false时(默认为fasle)显示编辑Todo的界面，
 * bool参数addTodo设置为true时(显示添加Todo的界面，
 * 注意：在addTodo模式下也需传入一个新的空Todo实例.
 */

class TodoEditDialog extends StatefulWidget {
  final Todo todo;
  final bool addTodo;

  const TodoEditDialog({Key key, @required this.todo, this.addTodo = false})
      : super(key: key);

  @override
  _TodoEditDialogState createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends State<TodoEditDialog> {
  final TextEditingController _titleEdit = TextEditingController();
  final TextEditingController _describeEdit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleEdit.text = widget.todo.title;
    _describeEdit.text = widget.todo.describe;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
            //*需根据标签数量更改为动态高度——采用ListView解决
            // height: ScreenUtil().setHeight(400),
            width: ScreenUtil().setWidth(355),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular((10.0))),
            child: Consumer2<TodosNotifier, TasksNotifier>(
                builder: (context, todosNotifier, tasksNotifier, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //*P1
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.addTodo ? "添加待办" : "编辑待办",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: InkWell(
                                child: Icon(Icons.close),
                                onTap: () => Navigator.pop(context),
                              ),
                            ),
                            Expanded(child: Container()),
                            //*Todo类型转换
                            widget.todo.type == 0
                                ? Container(
                                    child: InkWell(
                                      child: Text("DONE"),
                                      onTap: () {
                                        //*完成——将Todo设置为Done
                                        widget.todo.type = 2;
                                        //?设置完成时间
                                        widget.todo.endTime = DateTime.now();
                                        todosNotifier.update(
                                            widget.todo.id, widget.todo);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                : Container(),
                            widget.todo.type == 2
                                ? Container(
                                    child: InkWell(
                                      child: Text("REDO"),
                                      onTap: () {
                                        //*重做——将Done重置为Todo
                                        widget.todo.type = 0;
                                        //?设置开始时间
                                        widget.todo.startTime = DateTime.now();
                                        todosNotifier.update(
                                            widget.todo.id, widget.todo);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //*P2
                  Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: pageMagrin * 1.5),
                        child: ListView(
                          //*使用关闭滑动事件的ListView实现自定义高度
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            //*标题&备注
                            //*TittleEdit
                            TextField(
                              controller: _titleEdit,
                              decoration: InputDecoration(
                                labelText: '标题',
                              ),
                            ),
                            //*DescribeEdit
                            TextField(
                              controller: _describeEdit,
                              decoration: InputDecoration(
                                labelText: '备注',
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            //?添加Todo-设置类型
                            widget.addTodo == true
                                ? Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          '类型',
                                          style: TextStyle(
                                            color: vColorMap['mainText'],
                                            fontSize: ScreenUtil().setSp(25),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                ScreenUtil().setHeight(10)),
                                        child: SetTodoTypeWidget(
                                          todo: widget.todo,
                                        ),
                                      ),
                                    ],
                                  )
                                :
                                //*时间
                                Container(
                                    height: ScreenUtil().setHeight(72),
                                    // color: Colors.blue,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            '时间',
                                            style: TextStyle(
                                              color: vColorMap['mainText'],
                                              fontSize: ScreenUtil().setSp(25),
                                            ),
                                          ),
                                        ),
                                        //!添加Todo时的显示样式
                                        //*3种Todo类型对应的显示样式
                                        timeShower(
                                            todosNotifier: todosNotifier),
                                      ],
                                    ),
                                  ),

                            //*标签
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '标签',
                                style: TextStyle(
                                  color: vColorMap['mainText'],
                                  fontSize: ScreenUtil().setSp(25),
                                ),
                              ),
                            ),
                            tagWrap(
                                tagIds: widget.todo.tagIds,
                                backGroundColor: vColorMap['icon'],
                                showEdit: true,
                                editIconColor: Colors.white,
                                ontap: () {
                                  //!EditTag
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return TagEditDialog(
                                          editToTodo: true,
                                          todo: widget.todo,
                                        );
                                      }).then((value) {
                                    setState(() {});
                                  });
                                }),
                          ],
                        ),
                      ),

                      //*P4
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(15),
                              0,
                              ScreenUtil().setWidth(12),
                              0,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(10)),
                            width: ScreenUtil().setWidth(133),
                            child: InkWell(
                              onTap: () {
                                //!删除待办 or 取消（添加）
                                if (widget.addTodo == true) {
                                  Navigator.pop(context);
                                } else {
                                  todosNotifier.delete(widget.todo.id);
                                  Navigator.pop(context);
                                }
                              },
                              child: Card(
                                elevation: 0,
                                color: Color(0xFFE8EAF6),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(8)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.addTodo ? "取消" : "删除待办",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(10)),
                            width: ScreenUtil().setWidth(180),
                            child: InkWell(
                              onTap: () {
                                //!保存改动 or 确认添加
                                if (_titleEdit.value != null) {
                                  widget.todo.title = _titleEdit.value.text;
                                }
                                if (_describeEdit.value != null) {
                                  widget.todo.describe =
                                      _describeEdit.value.text;
                                }
                                //!Time
                                widget.todo.startTime =
                                    widget.todo.endTime = DateTime.now();

                                if (widget.addTodo == true) {
                                  todosNotifier.insert(widget.todo);
                                }
                                Navigator.pop(context);
                              },
                              child: Card(
                                elevation: 0,
                                color: Color(0xFF8C9EFF),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(8)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.addTodo ? "确认添加" : "保存改动",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17),
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              );
            })),
      ),
    );
  }

  Widget timeShower({TodosNotifier todosNotifier}) {
    int type = widget.todo.type;

    //当前选中的日期
    DateTime _selectedDate = widget.todo.startTime ?? DateTime.now();

    if (type == 0) {
      _selectedDate = widget.todo.startTime ?? DateTime.now();
    } else if (type == 2) {
      _selectedDate = widget.todo.endTime ?? DateTime.now();
    }

    //调起日期选择器
    _showDatePicker() {
      //获取异步方法里面的值的第一种方式：then
      showDatePicker(
        //如下四个参数为必填参数
        context: context,
        initialDate: _selectedDate, //选中的日期
        firstDate: type == 0 ? DateTime.now() : DateTime(1980), //日期选择器上可选择的最早日期
        lastDate: type == 2 ? DateTime.now() : DateTime(2100), //日期选择器上可选择的最晚日期
      ).then((selectedValue) {
        setState(() {
          if (selectedValue != null) {
            //将选中的值传递出来
            _selectedDate = selectedValue;
            //*更新todo
            if (type == 0) {
              widget.todo.startTime = _selectedDate;
            } else if (type == 2) {
              widget.todo.endTime = _selectedDate;
            }
            todosNotifier.update(widget.todo.id, widget.todo);
          }
        });
      });
    }

    //调起时间选择器
    _showTimePicker() async {
      // 获取异步方法里面的值的第二种方式：async+await
      //await的作用是等待异步方法showDatePicker执行完毕之后获取返回值
      var result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate), //选中的时间
      );
      //将选中的值传递出来
      if (result != null) {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
            _selectedDate.day, result.hour, result.minute);
        if (type == 0 && _selectedDate.isBefore(DateTime.now())) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Center(child: Text("提示")),
              children: [
                SimpleDialogOption(
                  child: Center(child: Text("开始时间不能早于当前时间，请重新选择")),
                )
              ],
            ),
          );
        } else if (type == 2 && _selectedDate.isAfter(DateTime.now())) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Center(child: Text("提示")),
              children: [
                SimpleDialogOption(
                  child: Center(child: Text("完成时间不能晚于当前时间，请重新选择")),
                )
              ],
            ),
          );
        } else {
          setState(() {
            //*更新todo
            if (type == 0) {
              widget.todo.startTime = _selectedDate;
            } else if (type == 2) {
              widget.todo.endTime = _selectedDate;
            }
            todosNotifier.update(widget.todo.id, widget.todo);
          });
        }
      }
    }

    if (type == 0 || type == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "计划开始时间：",
              style: TextStyle(color: vColorMap['subText']),
            ),
          ),
          InkWell(
            onTap: () {
              _showDatePicker();
            },
            child: Row(
              children: [
                Text(
                  "${formatDate(_selectedDate, [yyyy, "-", mm, "-", "dd"])}",
                  style: TextStyle(color: vColorMap['subText']),
                ),
                Icon(Icons.arrow_drop_down, color: vColorMap['subText'])
              ],
            ),
          ),
          InkWell(
            onTap: () {
              _showTimePicker();
            },
            child: Row(
              children: [
                Text(
                  "${TimeOfDay.fromDateTime(_selectedDate).format(context)}",
                  style: TextStyle(color: vColorMap['subText']),
                ),
                Icon(Icons.arrow_drop_down, color: vColorMap['subText'])
              ],
            ),
          ),
        ],
      );
    } else if (type == 1) {
      return Row(
        children: [
          //?
          // Container(
          //   child: Text(
          //     "已进行：",
          //     style: TextStyle(color: vColorMap['subText']),
          //   ),
          // ),
        ],
      );
    } else if (type == 2) {
      return Row(
        children: [
          Container(
            child: Text(
              "完成时间：",
              style: TextStyle(color: vColorMap['subText']),
            ),
          ),
          InkWell(
            onTap: () {
              _showDatePicker();
            },
            child: Row(
              children: [
                Text(
                  "${formatDate(_selectedDate, [yyyy, "-", mm, "-", "dd"])}",
                  style: TextStyle(color: vColorMap['subText']),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
          InkWell(
            onTap: () {
              _showTimePicker();
            },
            child: Row(
              children: [
                Text(
                  "${TimeOfDay.fromDateTime(_selectedDate).format(context)}",
                  style: TextStyle(color: vColorMap['subText']),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ],
      );
    }
    return Container(
      child: Text("出错啦~"),
    );
  }
}
