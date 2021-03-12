import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';
import 'package:vistima_00/widgets/TagWrap.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({Key key, @required this.task}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _titleEdit = TextEditingController();
  final TextEditingController _describeEdit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleEdit.text = widget.task.title;
    _describeEdit.text = widget.task.describe;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: FlatButton(
          onPressed: () {
            //!取消 or 返回？
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            size: ScreenUtil().setHeight(36),
            color: Colors.grey,
          ),
        ),
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleEdit,
                decoration: InputDecoration(
                  labelText: '标题',
                ),
              ),
              TextField(
                controller: _describeEdit,
                decoration: InputDecoration(
                  labelText: '备注',
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '时间',
                  style: TextStyle(
                    color: vColorMap['mainText'],
                    fontSize: ScreenUtil().setSp(25),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(98),
                color: Colors.lightGreen,
              ),
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
              Container(
                child: tagWrap(
                    tagIds: widget.task.tagIds,
                    backGroundColor: vColorMap['icon']),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '笔记',
                  style: TextStyle(
                    color: vColorMap['mainText'],
                    fontSize: ScreenUtil().setSp(25),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(177),
                color: Colors.lightBlue,
              ),
            ],
          )
        ],
      ),
    );
  }
}
