import 'package:flutter/cupertino.dart';
import 'package:vistima_00/model/SQLHelper.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/utils.dart';

class TasksNotifier extends ChangeNotifier {
  List<Task> _tasks;

  TasksNotifier({List<Task> tasks}) {
    _tasks = tasks ?? [];
  }

  //*获取&更新_tasks
  Future<void> _refresh() async {
    _tasks = await SQLHelper.retrieveTasks();
    notifyListeners();
  }

  //*初始化测试数据
  Future<void> initTest() async {
    await SQLHelper.initialTest();
    await _refresh();
  }

  //*按id获取task
  Task tasksInId(int id) {
    return _tasks.singleWhere((task) => task.id == id);
  }

  //*获取本日task
  List<Task> tasksInDate(DateTime date) {
    return _tasks
        .where((t) => TimeUtil.isInSameDay(t.startTime, date))
        .toList()
        .reversed
        .toList();
  }

  //*获取本周task
  List<Task> tasksInWeek(DateTime date) {
    return _tasks
        .where((t) => TimeUtil.isInSameWeek(t.startTime, date))
        .toList()
        .reversed
        .toList();
  }

  //*获取本月task
  List<Task> tasksInMonth(DateTime date) {
    return _tasks
        .where((t) => TimeUtil.isInSameMonth(t.startTime, date))
        .toList()
        .reversed
        .toList();
  }

  //*按tag获取task
  List<Task> tasksInTag(int tagId) {
    return _tasks
        .where((t) => t.tagIds.contains(tagId))
        .toList()
        .reversed
        .toList();
  }

  //*添加task
  Future<int> insert(Task task) async {
    int id = await SQLHelper.insertTask(task);
    await _refresh();
    return id;
  }

  //*删除task
  Future<void> delete(int id) async {
    await SQLHelper.deleteTask(id);
    await _refresh();
  }

  //*更新task
  Future<void> update(int id, Task newTask) async {
    await SQLHelper.updateTask(id, newTask);
    await _refresh();
  }

  //*更新task的tagId
  Future<void> updatetagId({int oldIds, int newId = -1}) async {
    var tasks = tasksInTag(oldIds);
    for (var task in tasks) {
      task.tagIds.remove(oldIds);
      if (newId != -1) task.tagIds.add(newId);
      await SQLHelper.updateTask(task.id, task);
    }
    await _refresh();
  }
}
