//-任务类
class Task {
  int id;
  List<dynamic> tagIds;
  String title;
  String describe;
  String note;
  String color;
  DateTime startTime;
  DateTime endTime;
  Duration timeCost;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tagIds': tagIds.toString(),
      'title': title,
      'describe': describe,
      'note': note,
      'color': color,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
    };
  }

  Task({
    this.id,
    this.tagIds,
    this.title,
    this.describe,
    this.note,
    this.color,
    this.startTime,
    this.endTime,
  }) : this.timeCost = endTime != null ? endTime.difference(startTime) : null;

  Todo toTodo({int type = 0}) {
    return Todo(
        title: title,
        describe: describe,
        tagIds: tagIds,
        startTime: startTime,
        endTime: endTime,
        type: type);
  }
}

//-Todo类
enum Type { todo, processing, done }

class Todo {
  int id;
  List<dynamic> tagIds;
  int type;
  String title;
  String describe;
  String color;
  DateTime startTime;
  DateTime endTime;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tagIds': tagIds.toString(),
      'type': type,
      'title': title,
      'describe': describe,
      'color': color,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
    };
  }

  Todo({
    this.id,
    this.tagIds,
    this.type,
    this.title,
    this.describe,
    this.color,
    this.startTime,
    this.endTime,
  });

  Task toTask() {
    return Task(
      title: title,
      tagIds: tagIds,
      describe: describe,
      startTime: startTime,
    );
  }
}

//-Tag类
class Tag {
  int id;
  String title;
  String color;
  int timeCost;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'timeCost': timeCost,
    };
  }

  Tag({
    this.id,
    this.title,
    this.color,
    this.timeCost = 0,
  });
}
