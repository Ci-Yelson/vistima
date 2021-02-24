import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vistima_00/model/model.dart';

class SQLHelper {
  //*建表
  static Future<Database> _getDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), 'vistima_0.db'),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "tagIds TEXT, title TEXT, describe TEXT, note TEXT, color TEXT, startTime TEXT, endTime TEXT);");
      await db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "tagIds TEXT, type INTEGER, title TEXT, describe TEXT, color TEXT, startTime TEXT, endTime TEXT);");
      await db.execute("CREATE TABLE tags(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT, color TEXT, timeCost INTEGER);");
    }, version: 1);
  }

  //*初始化测试数据
  static Future<void> initialTest() async {
    final Database db = await _getDatabase();
    await db.delete('tasks');
    await db.delete('todos');
    await db.delete('tags');

    Tag tag1 = Tag(id: 1, title: "学习");
    Tag tag2 = Tag(id: 2, title: "生活");
    await db.insert('tags', tag1.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await db.insert('tags', tag2.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    Todo todo1 = Todo(
      id: 11,
      tagIds: [1, 2],
      title: "todo",
      type: 0,
      describe: "todo描述",
      startTime: DateTime.now().add(Duration(hours: 1)),
      endTime: DateTime.now().add(Duration(hours: 1)),
    );
    Todo todo2 = Todo(
      id: 12,
      tagIds: [1],
      title: "processing",
      type: 1,
      describe: "processing描述",
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    );
    Todo todo3 = Todo(
        id: 13,
        tagIds: [2],
        title: "done",
        type: 2,
        describe: "done描述",
        startTime: DateTime.now().add(Duration(hours: -2)),
        endTime: DateTime.now().add(Duration(hours: -1)));

    await db.insert('todos', todo1.toMap());
    await db.insert('todos', todo2.toMap());
    await db.insert('todos', todo3.toMap());

    Task task1 = Task(
      id: 101,
      tagIds: [1, 2],
      title: "测试Task1",
      describe: "Task1任务描述",
      startTime: DateTime.now().add(Duration(hours: -3)),
      endTime: DateTime.now().add(Duration(hours: -2)),
    );
    await db.insert('tasks', task1.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    LogUtil.e(0, tag: '>initTest');
  }

  //*删除task表
  static Future<void> deleteAllTasks() async {
    final Database db = await _getDatabase();
    await db.delete(
      'tasks',
    );
  }

  //*检索task数据-返回tasklist
  static Future<List<Task>> retrieveTasks() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    // LogUtil.e(maps, tag: 'tasksMap');

    List<Task> taskList = [];
    for (Map map in maps) {
      Task _task = Task(
          id: map['id'],
          tagIds: json.decode(map['tagIds']),
          title: map['title'],
          describe: map['describe'],
          note: map['note'],
          startTime: DateTime.parse(map['startTime']),
          endTime: DateTime.parse(map['endTime']));

      taskList.add(_task);
    }

    // LogUtil.e(taskList, tag: '>taskList');
    return taskList.reversed.toList();
  }

  //*检索todo数据-返回todolist
  static Future<List<Todo>> retrieveTodos() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('todos');
    // LogUtil.e(maps, tag: 'todosMap');

    List<Todo> todoList = List.generate(
        maps.length,
        (i) => Todo(
            id: maps[i]['id'],
            tagIds: json.decode(maps[i]['tagIds']),
            type: maps[i]['type'],
            title: maps[i]['title'],
            describe: maps[i]['describe'],
            startTime: DateTime.parse(maps[i]['startTime']),
            endTime: DateTime.parse(maps[i]['endTime'])));

    // LogUtil.e(todoList, tag: '>todoList');
    return todoList;
  }

  //*检索tag数据-返回taglist
  static Future<List<Tag>> retrieveTags() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tags');

    List<Tag> taglist = List.generate(
        maps.length,
        (i) => Tag(
            id: maps[i]['id'],
            title: maps[i]['title'],
            timeCost: maps[i]['timeCost']));
    // LogUtil.e(taglist, tag: '>taglist');
    return taglist;
  }
}
