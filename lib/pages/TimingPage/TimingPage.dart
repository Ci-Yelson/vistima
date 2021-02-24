import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:flutter/material.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/TimingPage/TimingNotifier.dart';
import 'package:vistima_00/pages/TimingPage/TimingTableWidget.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/widgets/TagEdit.dart';
import 'package:vistima_00/widgets/TagWrap.dart';

class TimingPage extends StatefulWidget {
  final Todo todo;

  TimingPage({Key key, @required this.todo}) : super(key: key);

  @override
  _TimingPageState createState() => _TimingPageState();
}

class _TimingPageState extends State<TimingPage> {
  TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    //*实例化_task
    Task _task = widget.todo.toTask();

    //*计时状态管理
    final timingNotifier = TimingNotifier();
    timingNotifier.startRecordTime();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          //*底层背景图片与高斯模糊
          Image.asset(
            'assets/images/A2-1.jpg',
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
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              //!下次继续
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
                          ),
                        ],
                      ),
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
                                    hintStyle: TextStyle(color: Colors.grey),
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
                            backGroundColor: Colors.grey,
                            showEdit: true,
                            ontap: () {
                              //!
                              LogUtil.e("tagEdit()");

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(10))),
                                      ),
                                      children: [
                                        addTag(),
                                        SimpleDialogOption(
                                          child: tagEdit(
                                            task: _task,
                                          ),
                                        ),
                                      ],
                                    );
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
                        alignment: Alignment.center,
                        child: Text(
                          "Note",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              color: Colors.white),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
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
}
