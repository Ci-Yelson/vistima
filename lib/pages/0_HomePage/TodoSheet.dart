import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/startViewModel.dart';
import 'package:vistima_00/viewmodel/todoViewModel.dart';
import 'package:vistima_00/widgets/TagWrap.dart';
import 'package:vistima_00/widgets/VCheckBox.dart';

class TodoSheet extends StatefulWidget {
  const TodoSheet({Key key}) : super(key: key);

  @override
  _TodoSheetState createState() => _TodoSheetState();
}

class _TodoSheetState extends State<TodoSheet>
    with AutomaticKeepAliveClientMixin {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    LogUtil.e('TodoSheet-build');
    return Container(
      width: todoSheetWidth,
      height: todoSheetHeight,
      color: greyBG,
      child: Container(
        height: todoSheetHeight,
        child: Consumer2<TodosNotifier, StartNotifier>(
            builder: (context, todosNotifier, startNotifier, _) {
          //*获取todos并分类显示
          List<Todo> allTodos = todosNotifier.getTodos();
          List<Todo> todos = allTodos.where((t) => t.type == 0).toList();
          List<Todo> processings = allTodos.where((t) => t.type == 1).toList();

          List<Widget> allList = todoList(
                  todos: processings, type: 1, startNotifier: startNotifier) +
              todoList(todos: todos, startNotifier: startNotifier);
          return ListView(
            padding: EdgeInsets.only(top: 0),
            children: allList,
          );
        }),
      ),
    );
  }

  //* type=1:ProcessingList; type=0:TodoList
  List<Widget> todoList(
      {@required List<Todo> todos,
      int type = 0,
      @required StartNotifier startNotifier}) {
    if (todos.isEmpty) return [Container()];
    return [
      Container(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(8),
          bottom: ScreenUtil().setHeight(8),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(4),
                bottom: ScreenUtil().setHeight(4),
                left: ScreenUtil().setWidth(4),
                right: ScreenUtil().setWidth(4),
              ),
              child: ClipOval(
                  child: Container(
                height: ScreenUtil().setHeight(5),
                width: ScreenUtil().setWidth(5),
                color: vColorMap['processing_todo'],
              )),
            ),
            Text(
              type == 0 ? "待完成" : "正在进行",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(15),
                  // fontFamily: textfont,
                  color: vColorMap['processing_todo']),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(6),
            ),
            Expanded(
                child: Container(
              height: 1,
              color: vColorMap['processing_todo'],
            ))
          ],
        ),
      ),
      //!如何使用Selector缩小刷新范围
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return todoCard(todo: todos[index], startNotifier: startNotifier);
        },
        itemCount: todos.length,
      )
    ];
  }

  Widget todoCard({Todo todo, @required StartNotifier startNotifier}) {
    return InkWell(
      onTap: () {
        //*选中事件处理
        //!
        setState(() {
          if (_selectIndex == todo.id) {
            _selectIndex = 0;
            todo = Todo(title: "无标题", tagIds: []);
          } else {
            _selectIndex = todo.id;
          }

          startNotifier.setTodo(todo);
          LogUtil.e(todo.toMap(), tag: 'TodoSelect');
        });
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // //*选中样式处理
            // Container(
            //   height: todoCardHeight,
            //   color: _selectIndex == todo.id
            //       ? Colors.grey.withAlpha(50)
            //       : Colors.transparent,
            // ),
            Row(
              children: [
                Container(
                  // height: todoCardHeight,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(4),
                    left: ScreenUtil().setWidth(10),
                  ),
                  child: Container(
                    width: ScreenUtil().setWidth(180),
                    // color: Colors.red,
                    child: ListView(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), //禁用滑动事件
                      children: [
                        Text(
                          todo.title,
                          style: TextStyle(fontSize: ScreenUtil().setSp(18)),
                        ),
                        //*tagWrap
                        tagWrap(
                            context: context,
                            tagIds: todo.tagIds,
                            backGroundColor: vColorMap['icon']),
                        //*
                        todo.type == 0 && todo.startTime != null
                            ? Container(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(4),
                                ),
                                child: Text(
                                  "计划开始时间：${formatDate(todo.startTime, [
                                    yyyy,
                                    '/',
                                    mm,
                                    '/',
                                    dd,
                                    ' - ',
                                    HH,
                                    ':',
                                    nn,
                                  ])}",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(12),
                                      color: Colors.grey),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container()),
                VCheckBox(isSelected: _selectIndex == todo.id),
                SizedBox(
                  width: ScreenUtil().setWidth(6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
