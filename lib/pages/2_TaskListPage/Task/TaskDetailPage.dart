import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/0_HomePage/TagEditDialog.dart';
import 'package:vistima_00/pages/2_TaskListPage/NoteEditorPage.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';
import 'package:vistima_00/widgets/TagWrap.dart';
import 'package:zefyr/zefyr.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final TasksNotifier tasksNotifier;

  const TaskDetailPage(
      {Key key, @required this.task, @required this.tasksNotifier})
      : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _titleEdit = TextEditingController();
  final TextEditingController _describeEdit = TextEditingController();

  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _titleEdit.text = widget.task.title;
    _describeEdit.text = widget.task.describe;
    _titleEdit.selection = TextSelection.fromPosition(
        TextPosition(offset: _titleEdit.text.length));
    _describeEdit.selection = TextSelection.fromPosition(
        TextPosition(offset: _describeEdit.text.length));

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 0.5,
        // leading: FlatButton(
        //   onPressed: () {
        //     //!取消 or 返回？
        //     Navigator.pop(context);
        //   },
        //   child: Icon(
        //     Icons.keyboard_arrow_left,
        //     size: ScreenUtil().setHeight(36),
        //     color: Colors.grey,
        //   ),
        // ),
        centerTitle: true,
        title: Text(
          '详细信息',
          style: TextStyle(
            color: vColorMap['mainText'],
            fontSize: ScreenUtil().setSp(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.grey,
              ),
              onPressed: () {
                //!save
                _saveDocument(context);
                widget.tasksNotifier.update(widget.task.id, widget.task);
                Navigator.pop(context);
              }),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onPressed: () {
                //!delete
                bool isDelete = false;
                return showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(10))),
                        ),
                        title: Center(child: Text('提示')),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: Center(
                                child: Text('是否删除',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(18)))),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Consumer<TasksNotifier>(
                                builder: (context, tasksNotifier, child) =>
                                    InkWell(
                                        onTap: () {
                                          tasksNotifier.delete(widget.task.id);
                                          isDelete = true;
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                            child: Text(
                                          '是',
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              color: Colors.blue),
                                        ))),
                              )),
                              Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Center(
                                          child: Text(
                                        '否',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(18),
                                            color: Colors.blue),
                                      )))),
                            ],
                          )
                        ],
                      );
                    }).then((value) {
                  if (isDelete) {
                    Navigator.pop(context);
                  }
                });
              })
        ],
      ),
      body: ZefyrScaffold(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //!BUG
                //*标题&备注
                TextField(
                  controller: _titleEdit,
                  style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '标题',
                    labelStyle: TextStyle(color: vColorMap['mainText']),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: vColorMap['mainText']),
                    ),
                  ),
                  onChanged: (value) {
                    widget.task.title = value;
                  },
                  onSubmitted: (value) {
                    widget.task.title = value;
                  },
                ),
                TextField(
                  controller: _describeEdit,
                  style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '备注',
                    labelStyle: TextStyle(color: vColorMap['mainText']),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: vColorMap['mainText']),
                    ),
                  ),
                  onSubmitted: (value) {
                    widget.task.describe = value;
                  },
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                //*时间
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
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
                            width: ScreenUtil().setWidth(6),
                          ),
                          Text(
                            '时间 ${widget.task.timeCost.inHours} h ${widget.task.timeCost.inMinutes} min',
                            style: TextStyle(
                              color: vColorMap['mainText'],
                              fontSize: ScreenUtil().setSp(25),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(4),
                    ),
                    _timeShower(
                        tasksNotifier: widget.tasksNotifier, task: widget.task),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                //*标签
                Container(
                  alignment: Alignment.centerLeft,
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
                        width: ScreenUtil().setWidth(6),
                      ),
                      Text(
                        '标签',
                        style: TextStyle(
                          color: vColorMap['mainText'],
                          fontSize: ScreenUtil().setSp(25),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(4),
                ),
                Container(
                  child: tagWrap(
                      tagIds: widget.task.tagIds,
                      backGroundColor: vColorMap['icon'],
                      showEdit: true,
                      editIconColor: Colors.white,
                      ontap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return TagEditDialog(
                                editToTask: true,
                                task: widget.task,
                              );
                            }).then((value) {
                          setState(() {});
                        });
                      }),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                //*笔记
                Container(
                  alignment: Alignment.centerLeft,
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
                        width: ScreenUtil().setWidth(6),
                      ),
                      Text(
                        '笔记',
                        style: TextStyle(
                          color: vColorMap['mainText'],
                          fontSize: ScreenUtil().setSp(25),
                        ),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              color: vColorMap['icon'],
                              onPressed: () {
                                Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                  return NoteEditorPage(
                                    task: widget.task,
                                  );
                                })).then((value) {
                                  _loadDocument().then((document) {
                                    setState(() {
                                      _controller = ZefyrController(document);
                                    });
                                  });
                                });
                              },
                              child: Text(
                                '编辑笔记',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(16)),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.task.note != null
                    ? widget.task.note.length != 17
                        ? buildEditor()
                        : Container(
                            height: ScreenUtil().setHeight(50),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ' 请输入笔记~',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  color: Colors.grey),
                            ),
                            color: Colors.transparent,
                          )
                    : Container(
                        height: ScreenUtil().setHeight(50),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ' 请输入笔记~',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              color: Colors.grey),
                        ),
                        color: Colors.transparent,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //!Widget待封装

  Widget _timeShower({TasksNotifier tasksNotifier, Task task}) {
    DateTime _startTime = task.startTime;
    DateTime _endTime = task.endTime;

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
            type == 0 ? task.startTime = _startTime : task.endTime = _endTime;
            tasksNotifier.update(task.id, task);
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
          type == 0 ? task.startTime = _startTime : task.endTime = _endTime;
          tasksNotifier.update(task.id, task);
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
        Row(
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
      ],
    );
  }

  Widget buildEditor() {
    return (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrField(
            height: ScreenUtil().setHeight(650),
            decoration: InputDecoration(
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            controller: _controller,
            focusNode: _focusNode,
            autofocus: false,
            mode: ZefyrMode(canEdit: false, canSelect: true, canFormat: true),
            // imageDelegate: CustomImageDelegate(),
            physics: ClampingScrollPhysics(),
          );
  }

  Future<NotusDocument> _loadDocument() async {
    if (widget.task.note != null) {
      return NotusDocument.fromJson(jsonDecode(widget.task.note));
    }
    return NotusDocument();
  }

  void _saveDocument(BuildContext context) {
    final contents = jsonEncode(_controller.document);
    widget.task.title = _titleEdit.text;
    widget.task.note = contents;
  }
}
