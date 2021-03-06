import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/1_TodoPage/TodoEditDialog.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/startViewModel.dart';
import 'package:vistima_00/viewmodel/todoViewModel.dart';
import 'package:vistima_00/widgets/TagWrap.dart';
import 'package:vistima_00/widgets/TimerWidget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        // physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: pageMagrin, right: pageMagrin),
        shrinkWrap: true,
        children: [
          //*P1
          SizedBox(
            height: ScreenUtil().setHeight(17),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset(
                    'assets/icons/详细描述.png',
                    width: ScreenUtil().setWidth(32),
                    height: ScreenUtil().setHeight(32),
                    color: vColorMap['subText'],
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(6),
                ),
                Container(
                  child: Text(
                    "待办事项",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(35),
                        color: vColorMap['subText'],
                        fontWeight: FontWeight.w600,
                        // letterSpacing: 1.3,
                        fontFamily: textfont),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: 1,
                )),
                TimerWidget()
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(3),
          ),
          //*P2
          Consumer2<TodosNotifier, StartNotifier>(
              builder: (context, todosNotifier, startNotifier, _) {
            //*获取todos并分类显示
            List<Todo> allTodos = todosNotifier.getTodos();
            List<Todo> todos = allTodos.where((t) => t.type == 0).toList();
            List<Todo> processings =
                allTodos.where((t) => t.type == 1).toList();
            List<Todo> dones = allTodos.where((t) => t.type == 2).toList();

            // List<Widget> allList = todoList(
            //         todos: processings,
            //         type: 1,
            //         startNotifier: startNotifier) +
            //     todoList(todos: todos, startNotifier: startNotifier) +
            //     todoList(
            //         todos: dones, type: 2, startNotifier: startNotifier);

            return ListView(
              padding: EdgeInsets.only(top: 0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                expansionList(
                    todos: processings, type: 1, startNotifier: startNotifier),
                expansionList(
                    todos: todos, type: 0, startNotifier: startNotifier),
                expansionList(
                    todos: dones, type: 2, startNotifier: startNotifier),
                Container(
                  // padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  // margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  // color: vColorMap['icon'],
                  child: InkWell(
                    onTap: () {
                      //!添加待办
                      showDialog(
                          context: context,
                          builder: (_) => TodoEditDialog(
                                todo: Todo(tagIds: []),
                                addTodo: true,
                              ));
                    },
                    child: Card(
                      elevation: 0,
                      color: vColorMap['icon'],
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(8)),
                        alignment: Alignment.center,
                        child: Text(
                          "添加待办",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(17),
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                )
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget expansionList(
      {@required List<Todo> todos,
      int type = 0,
      @required StartNotifier startNotifier}) {
    String borderTiltle = "待完成";
    if (type == 1)
      borderTiltle = "正在进行";
    else if (type == 2) borderTiltle = "已完成";
    return ExpansionTile(
      backgroundColor: Colors.transparent,
      childrenPadding: EdgeInsets.zero,
      tilePadding: EdgeInsets.symmetric(horizontal: 16),
      title: Container(
        height: ScreenUtil().setHeight(30),
        // color: Colors.blue,
        child: Row(
          children: [
            Text(
              borderTiltle,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  // fontFamily: textfont,
                  color: vColorMap['processing_todo']),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              margin: EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                "${todos.length}",
                style: TextStyle(color: Colors.white),
              ),
              color: vColorMap['processing_todo'],
            ),
            Expanded(
                child: Container(
              height: 1.5,
              color: vColorMap['processing_todo'],
            ))
          ],
        ),
      ),
      initiallyExpanded: type == 1 ? true : false,
      children:
          todoList(todos: todos, type: type, startNotifier: startNotifier),
    );
  }

  //* type=0:TodoList; type=1:ProcessingList; type=2:DoneList;
  List<Widget> todoList(
      {@required List<Todo> todos,
      int type = 0,
      @required StartNotifier startNotifier}) {
    if (todos.isEmpty) return [Container()];

    return [
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
        //!点击事件处理
        // LogUtil.e("tap-${todo.id}");
        showDialog(
            context: context,
            builder: (_) => TodoEditDialog(
                  todo: todo,
                )).then((value) {
          setState(() {});
        });
      },
      child: Card(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(25),
                bottom: ScreenUtil().setHeight(29),
                left: ScreenUtil().setWidth(11),
                right: ScreenUtil().setWidth(6),
              ),
              child: ClipOval(
                  child: Container(
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                color: vColorMap['processing_todo'],
              )),
            ),
            Container(
              // height: todoCardHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(4),
                left: ScreenUtil().setWidth(10),
              ),
              child: Container(
                width: ScreenUtil().setWidth(300),
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
                    //*开始/完成时间
                    todo.type == 0 && todo.startTime != null
                        ? Container(
                            padding: EdgeInsets.only(
                              bottom: ScreenUtil().setHeight(4),
                            ),
                            child: Text(
                              "计划开始时间：${formatDate(todo.startTime, [
                                yy,
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
                        : Container(),
                    todo.type == 2 && todo.endTime != null
                        ? Container(
                            padding: EdgeInsets.only(
                              bottom: ScreenUtil().setHeight(4),
                            ),
                            child: Text(
                              "完成时间：${formatDate(todo.endTime, [
                                yy,
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
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
