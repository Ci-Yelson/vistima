import 'package:flutter/cupertino.dart';
import 'package:vistima_00/model/SQLHelper.dart';
import 'package:vistima_00/model/model.dart';

class TagsNotifier extends ChangeNotifier {
  List<Tag> _tags;

  TagsNotifier({List<Tag> tags}) {
    _tags = tags ?? [];
  }

  //*获取&更新_tags
  Future<void> _refresh() async {
    _tags = await SQLHelper.retrieveTags();
    notifyListeners();
  }

  //*初始化测试数据
  Future<void> initTest() async {
    await SQLHelper.initialTest();
    await _refresh();
  }

  //*按id获取tag
  Tag tagsInId(int id) {
    return _tags.singleWhere((tag) => tag.id == id);
  }

  List<Tag> getTags() => _tags;

  //*添加tag
  Future<int> insert(Tag tag) async {
    int id = await SQLHelper.insertTag(tag);
    await _refresh();
    return id;
  }

  //*删除tag
  Future<void> delete(int id) async {
    await SQLHelper.deleteTag(id);
    await _refresh();
  }

  //*更新tag
  Future<void> update(int id, Tag newTag) async {
    await SQLHelper.updateTag(id, newTag);
    await _refresh();
  }
}
