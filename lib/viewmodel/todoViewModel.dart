import 'package:flutter/cupertino.dart';
import 'package:vistima_00/model/SQLHelper.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/utils.dart';

class TodosNotifier extends ChangeNotifier {
  List<Todo> _todos;

  TodosNotifier({List<Todo> todos}) {
    _todos = todos ?? [];
  }

  //*获取&更新_todos
  Future<void> _refresh() async {
    _todos = await SQLHelper.retrieveTodos();
    notifyListeners();
  }

  //*初始化测试数据
  Future<void> initTest() async {
    await SQLHelper.initialTest();
    await _refresh();
  }

  //*按id获取todo
  Todo todosInId(int id) {
    return _todos.singleWhere((todo) => todo.id == id);
  }

  //*按日期获取todo
  List<Todo> todosInDate(DateTime date) {
    return _todos
        .where((t) => TimeUtil.isInSameDay(t.startTime, date))
        .toList()
        .reversed
        .toList();
  }

  //*按tag获取todo
  List<Todo> todosInTag(int tagId) {
    return _todos
        .where((t) => t.tagIds.contains(tagId))
        .toList()
        .reversed
        .toList();
  }

  //*按type获取todo
  List<Todo> todosInType(int type) {
    return _todos.where((t) => t.type == type).toList();
  }

  List<Todo> getTodos() => _todos;

  //*添加todo
  Future<int> insert(Todo todo) async {
    int id = await SQLHelper.insertTodo(todo);
    await _refresh();
    return id;
  }

  //*删除todo
  Future<void> delete(int id) async {
    await SQLHelper.deleteTodo(id);
    await _refresh();
  }

  //*更新todo
  Future<void> update(int id, Todo newTodo) async {
    await SQLHelper.updateTodo(id, newTodo);
    await _refresh();
  }
}
