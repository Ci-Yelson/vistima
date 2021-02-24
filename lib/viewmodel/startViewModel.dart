import 'package:flutter/cupertino.dart';
import 'package:vistima_00/model/model.dart';

class StartNotifier extends ChangeNotifier {
  Todo _todo = Todo(title: '无标题', tagIds: []);

  Todo getTodo() => _todo;

  void setTodo(Todo todo) {
    _todo = todo;
    notifyListeners();
  }

  void setTodoTagIds({dynamic tagId, bool add = true}) {
    add ? _todo.tagIds.add(tagId) : _todo.tagIds.remove(tagId);
    notifyListeners();
  }
}
