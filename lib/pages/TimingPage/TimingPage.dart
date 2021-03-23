import 'dart:convert';
import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:flutter/material.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/0_HomePage/TagEditDialog.dart';
import 'package:vistima_00/pages/2_TaskListPage/NoteEditorPage.dart';
import 'package:vistima_00/pages/2_TaskListPage/TaskDetailPage.dart';
import 'package:vistima_00/pages/TimingPage/TimingNotifier.dart';
import 'package:vistima_00/pages/TimingPage/TimingTableWidget.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';
import 'package:vistima_00/viewmodel/todoViewModel.dart';
import 'package:vistima_00/widgets/TagEdit.dart';
import 'package:vistima_00/widgets/TagWrap.dart';
import 'package:zefyr/zefyr.dart';

class TimingPage extends StatefulWidget {
  final Todo todo;
  final int startType; //*3种开始方式 {0,1,2}

  TimingPage({Key key, @required this.todo, this.startType = 2})
      : super(key: key);

  @override
  _TimingPageState createState() => _TimingPageState();
}

class _TimingPageState extends State<TimingPage> {
  TextEditingController titleController = TextEditingController();

  ZefyrController _controller;
  FocusNode _focusNode;
  Task _task;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    //*实例化_task
    _task = widget.todo.toTask();

    //*计时状态管理
    final timingNotifier = TimingNotifier();
    _task.startTime = DateTime.now();
    timingNotifier.startRecordTime();

    return Stack(
      children: [
        //*底层背景图片与高斯模糊
        Image.asset(
          'assets/images/71.jpeg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withAlpha(50),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomPadding: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              //*上层界面
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //*状态栏高度
                      SizedBox(
                        height: ScreenUtil().setHeight(25),
                      ),
                      //*AppBar
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Text(
                                  '取消',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(24),
                                      color: Colors.white,
                                      letterSpacing: 1.3),
                                ),
                              )),
                        ],
                      ),
                      //*ClockTable
                      ChangeNotifierProvider.value(
                          value: timingNotifier, child: TimingTable()),
                      //*暂停与完成按钮
                      glassCardWidget(
                        sigma: 10,
                        child: Container(
                          color: Colors.transparent,
                          height: ScreenUtil().setHeight(53),
                          alignment: Alignment.center,
                          child: Consumer2<TasksNotifier, TodosNotifier>(
                              builder: (context, tasksNotifier, todosNotifier,
                                  child) {
                            return Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      //!下次继续
                                      LogUtil.e(widget.startType,
                                          tag: "widget.startType");
                                      //*3种开始方式分别处理 {0,1,2}
                                      if (widget.startType == 0 ||
                                          widget.startType == 2) {
                                        Todo newProcessing =
                                            _task.toTodo(type: 1);
                                        //*
                                        newProcessing.endTime = DateTime.now();
                                        todosNotifier.insert(newProcessing);
                                      } else if (widget.startType == 1) {
                                        if (widget.todo.type == 0) {
                                          // todosNotifier
                                          //     .todosInId(widget.todo.id)
                                          //     .type = 1;
                                          // //*
                                          // todosNotifier.notifyListeners();
                                          widget.todo.type = 1;
                                          todosNotifier.update(
                                              widget.todo.id, widget.todo);
                                        }
                                      }

                                      //*AddTask
                                      timingNotifier.tapStop();
                                      addTask(
                                          task: _task,
                                          tasksNotifier: tasksNotifier,
                                          titleController: titleController);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(46),
                                        right: ScreenUtil().setWidth(45),
                                      ),
                                      child: Text(
                                        "下次继续",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(20),
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(1),
                                    height: ScreenUtil().setWidth(30),
                                    color: Colors.white,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      //!完成

                                      //*3种开始方式分别处理 {0,1,2} (仅对方式2进行处理)
                                      if (widget.startType == 1) {
                                        // todosNotifier
                                        //     .todosInId(widget.todo.id)
                                        //     .type = 2;
                                        // //*
                                        // todosNotifier.notifyListeners();
                                        widget.todo.type = 2;
                                        todosNotifier.update(
                                            widget.todo.id, widget.todo);
                                      }

                                      //*AddTask
                                      timingNotifier.tapStop();
                                      addTask(
                                          task: _task,
                                          tasksNotifier: tasksNotifier,
                                          titleController: titleController);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(69),
                                        right: ScreenUtil().setWidth(64),
                                      ),
                                      child: Text(
                                        "完成",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(20),
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ]);
                          }),
                        ),
                      ),
                      //*任务信息栏
                      Container(
                        height: ScreenUtil().setHeight(84),
                        width: ScreenUtil().setWidth(218),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: ScreenUtil().setHeight(36),
                                child: TextField(
                                    // maxLength: 20,
                                    controller: titleController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintText: "${_task.title}",
                                        hintStyle:
                                            TextStyle(color: Colors.white70),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        counterStyle:
                                            TextStyle(color: Colors.grey)))),
                            //*tagWrap
                            tagWrap(
                                context: context,
                                tagIds: _task.tagIds,
                                backGroundColor: Colors.white38,
                                editIconColor: Colors.white,
                                showEdit: true,
                                ontap: () {
                                  //!
                                  LogUtil.e("tagEdit()");

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return TagEditDialog(
                                          editToTodo: true,
                                          todo: widget.todo,
                                          useBlur: true,
                                        );
                                      }).then((value) {
                                    setState(() {});
                                  });
                                }),
                          ],
                        ),
                      ),
                      //*Note栏
                      glassCardWidget(
                          sigma: 12,
                          child: Container(
                              height: ScreenUtil().setHeight(250),
                              width: ScreenUtil().setWidth(344),
                              alignment: Alignment.topCenter,
                              child: Column(
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
                                          color: Colors.white,
                                        )),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(6),
                                        ),
                                        Text(
                                          'Note',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(18),
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: FlatButton(
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                color: Colors.transparent,
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      PageRouteBuilder(pageBuilder:
                                                          (BuildContext context,
                                                              Animation<double>
                                                                  animation,
                                                              Animation<double>
                                                                  secondaryAnimation) {
                                                    return NoteEditorPage(
                                                      task: _task,
                                                      controller: _controller,
                                                    );
                                                  })).then((value) {
                                                    _loadDocument()
                                                        .then((document) {
                                                      setState(() {
                                                        //!
                                                        _controller =
                                                            ZefyrController(
                                                                document);
                                                        _task.note = jsonEncode(
                                                            _controller
                                                                .document);
                                                        LogUtil.e(_task.note,
                                                            tag: "_task.note");
                                                      });
                                                    });
                                                  });
                                                },
                                                child: Text(
                                                  '编辑笔记',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(16)),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _task.note != null
                                      ? _task.note.length != 17
                                          ? buildEditor()
                                          : Container(
                                              height:
                                                  ScreenUtil().setHeight(50),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ' 请输入笔记~',
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(16),
                                                    color: Colors.white38),
                                              ),
                                              color: Colors.transparent,
                                            )
                                      : Container(
                                          height: ScreenUtil().setHeight(50),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            ' 请输入笔记~',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(16),
                                                color: Colors.white38),
                                          ),
                                          color: Colors.transparent,
                                        ),
                                ],
                              )))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget glassCardWidget({double sigma, Widget child}) {
    return Card(
      elevation: 0,
      color: Colors.white.withAlpha(50),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: child,
        ),
      ),
    );
  }

  addTask(
      {TextEditingController titleController,
      Task task,
      TasksNotifier tasksNotifier}) {
    if (titleController.value.text.isNotEmpty) {
      task.title = titleController.text;
    }
    task.endTime = DateTime.now();
    task.timeCost = task.endTime.difference(task.startTime);

    //*添加task
    tasksNotifier.insert(task).then((id) {
      task.id = id;
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(pageBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TaskDetailPage(
              task: task,
              tasksNotifier: tasksNotifier,
            );
          }, transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              child: child,
            );
          })).then((v) {
        setState(() {});
      });
    });
  }

  Future<NotusDocument> _loadDocument() async {
    if (_task.note != null) {
      return NotusDocument.fromJson(jsonDecode(_task.note));
    }
    return NotusDocument();
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
}
