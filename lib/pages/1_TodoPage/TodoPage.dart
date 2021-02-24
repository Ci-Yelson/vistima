import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/startViewModel.dart';
import 'package:vistima_00/viewmodel/todoViewModel.dart';
import 'package:vistima_00/widgets/TagWrap.dart';

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
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(left: pageMagrin, right: pageMagrin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //*P1
            SizedBox(
              height: ScreenUtil().setHeight(17),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: ScreenUtil().setWidth(32),
                  ),
                  Container(
                    child: Image.asset(
                      'assets/icons/详细描述.png',
                      width: ScreenUtil().setWidth(32),
                      height: ScreenUtil().setHeight(32),
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
                          color: vColorMap['mainText'],
                          fontWeight: FontWeight.w600,
                          // letterSpacing: 1.3,
                          fontFamily: textfont),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    width: 1,
                  )),
                  Container(
                    child: InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/icons/名称顺序.png',
                          width: ScreenUtil().setWidth(35),
                          height: ScreenUtil().setHeight(35),
                        )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(18),
            ),
            //*P2
            Container(
              height: ScreenUtil().setHeight(500),
              child: Consumer2<TodosNotifier, StartNotifier>(
                  builder: (context, todosNotifier, startNotifier, _) {
                //*获取todos并分类显示
                List<Todo> allTodos = todosNotifier.getTodos();
                List<Todo> todos = allTodos.where((t) => t.type == 0).toList();
                List<Todo> processings =
                    allTodos.where((t) => t.type == 1).toList();

                List<Widget> allList = todoList(
                        todos: processings,
                        type: 1,
                        startNotifier: startNotifier) +
                    todoList(todos: todos, startNotifier: startNotifier);
                return ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: allList,
                );
              }),
            ),
          ],
        ),
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
                  fontSize: ScreenUtil().setSp(20),
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
        //!点击事件处理
        // LogUtil.e("tap-${todo.id}");
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
              height: todoCardHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(6),
                left: ScreenUtil().setWidth(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                ],
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
