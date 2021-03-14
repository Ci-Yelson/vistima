import 'package:circular_check_box/circular_check_box.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';
import 'package:vistima_00/viewmodel/todoViewModel.dart';

class TagEditNotifier extends ChangeNotifier {
  List<dynamic> tagSelectValues;

  TagEditNotifier({this.tagSelectValues});

  isOnSelected(Tag tag) {
    if (!tagSelectValues.contains(tag.id)) {
      tagSelectValues.add(tag.id);
      notifyListeners();
    } else {
      tagSelectValues.remove(tag.id);
      notifyListeners();
    }
  }
}

class TagEditPage extends StatelessWidget {
  Widget buildTagItem(bool isSelected, Tag tag) {
    return Container(
      height: ScreenUtil().setHeight(42),
      child: Row(
        children: [
          SizedBox(width: ScreenUtil().setWidth(10)),
          Container(
            width: 24,
            height: 24,
            child: FittedBox(
              child: CircularCheckBox(
                value: isSelected,
                onChanged: null,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(10),
          ),
          Container(
            child: Text(
              "${tag.title}",
              style: TextStyle(fontSize: ScreenUtil().setSp(20)),
            ),
          )
        ],
      ),
    );
  }

  Widget addTagDialog(BuildContext context, TagsNotifier tagsNotifier) {
    final TextEditingController textEditingController = TextEditingController();
    FocusNode focusNode = FocusNode();

    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: focusNode,
            controller: textEditingController,
            // autofocus: true,
            style: TextStyle(fontSize: ScreenUtil().setSp(18)),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 1),
              hintText: '添加新标签',
              border: OutlineInputBorder(),
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //!添加标签
              if (textEditingController.value.text != null &&
                  textEditingController.value.text.length > 0) {
                tagsNotifier
                    .insert(Tag(title: textEditingController.value.text));
                focusNode.unfocus();
              }
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "编辑标签",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(20),
          ),
        ),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider.value(
          value: TagEditNotifier(tagSelectValues: []),
          child: Consumer4<TagEditNotifier, TagsNotifier, TodosNotifier,
              TasksNotifier>(
            builder: (context, tagEditNotifier, tagsNotifier, todosNotifier,
                tasksNotifier, _) {
              List<Tag> tags = tagsNotifier.getTags();
              LogUtil.e(tags, tag: 'TagEditDialog');
              // List<Tag> tags =
              //     tags + tags + tags + tags + tags + tags + tags + tags + tags;

              return ListView(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(620),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: pageMagrin, vertical: pageMagrin),
                          child: Column(
                            children: List.generate(
                                tags.length,
                                (index) => InkWell(
                                      child: buildTagItem(
                                          tagEditNotifier.tagSelectValues
                                              .contains(tags[index].id),
                                          tags[index]),
                                      onTap: () {
                                        tagEditNotifier
                                            .isOnSelected(tags[index]);
                                      },
                                    )),
                          ),
                        ),
                        Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: pageMagrin),
                            child: addTagDialog(context, tagsNotifier)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        // height: ScreenUtil().setHeight(37),
                        margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(20)),
                        width: ScreenUtil().setWidth(133),
                        child: InkWell(
                          onTap: () {
                            //!删除标签
                            for (var id in tagEditNotifier.tagSelectValues) {
                              //*先清除todo和task所连接的tagId，然后再删除tag
                              todosNotifier.updatetagId(oldIds: id);
                              tasksNotifier.updatetagId(oldIds: id);
                              tagsNotifier.delete(id);
                            }
                          },
                          child: Card(
                            elevation: 0,
                            color: Color(0xFFE8EAF6),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(8)),
                              alignment: Alignment.center,
                              child: Text(
                                "删除标签",
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(17)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // height: ScreenUtil().setHeight(37),
                        margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(20)),
                        width: ScreenUtil().setWidth(180),
                        child: InkWell(
                          onTap: () {
                            //!
                            Navigator.pop(context);
                          },
                          child: Card(
                            elevation: 0,
                            color: Color(0xFF8C9EFF),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(8)),
                              alignment: Alignment.center,
                              child: Text(
                                "保存改动",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(17),
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }
}
