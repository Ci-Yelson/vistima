import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/viewmodel/startViewModel.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';
import 'package:vistima_00/widgets/VCheckBox.dart';

class TagSheet extends StatefulWidget {
  const TagSheet({Key key}) : super(key: key);

  @override
  _TagSheetState createState() => _TagSheetState();
}

class _TagSheetState extends State<TagSheet> {
  Todo _todo;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: tagSheetHeight,
        alignment: Alignment.topCenter,
        color: greyBG,
        child: Consumer2<TagsNotifier, StartNotifier>(
            builder: (context, tagsNotifier, startNotifier, _) {
          //*初始化_todo
          _todo = startNotifier.getTodo();
          List<Tag> tags = tagsNotifier.getTags();
          return ListView.builder(
            padding: EdgeInsets.only(top: 3),
            itemBuilder: (context, index) {
              return tagCard(tag: tags[index], startNotifier: startNotifier);
            },
            itemCount: tags.length,
          );
        }));
  }

  Widget tagCard({Tag tag, StartNotifier startNotifier}) {
    return InkWell(
      onTap: () {
        //*选中事件处理
        dynamic id = tag.id;
        setState(() {
          if (_todo.tagIds.contains(id)) {
            startNotifier.setTodoTagIds(tagId: id, add: false);
          } else {
            startNotifier.setTodoTagIds(tagId: id);
          }
          LogUtil.e(_todo.toMap(), tag: 'TagSelect');
        });
      },
      child: Card(
        child: Stack(
          children: [
            // Container(
            //   height: tagCardHeight,
            //   color: _todo.tagIds.contains(tag.id)
            //       ? Colors.grey.withAlpha(50)
            //       : Colors.transparent,
            // ),
            Row(
              children: [
                Container(
                    height: tagCardHeight,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Text(
                      tag.title,
                      style: TextStyle(fontSize: ScreenUtil().setSp(18)),
                    )),
                Expanded(child: Container()),
                VCheckBox(isSelected: _todo.tagIds.contains(tag.id)),
                SizedBox(
                  width: ScreenUtil().setWidth(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
