import 'package:circular_check_box/circular_check_box.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';

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

Future<void> showTagEditDialog(BuildContext context) {
  Widget buildTagItem(bool isSelected, Tag tag) {
    return Row(
      children: [
        CircularCheckBox(
          value: isSelected,
          onChanged: null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        Container(
          child: Text(
            "${tag.title}",
            style: TextStyle(fontSize: ScreenUtil().setSp(22)),
          ),
        )
      ],
    );
  }

  Widget addTagDialog(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
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
        Consumer<TagsNotifier>(builder: (context, tagsNotifier, _) {
          List<Tag> tags = tagsNotifier.getTags();
          return IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                tags.add(Tag(title: textEditingController.value.text));
              });
          // return InkWell(
          //   onTap: () {
          //     tags.add(Tag(title: textEditingController.value.text));
          //     Navigator.pop(context);
          //   },
          //   child: Card(
          //     elevation: 0,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(
          //           Radius.circular(ScreenUtil().setWidth(10))),
          //     ),
          //     color: Color(0xFFE8EAF6),
          //     child: Container(
          //       height: ScreenUtil().setHeight(37),
          //       width: ScreenUtil().setHeight(133),
          //       alignment: Alignment.center,
          //       child: Text(
          //         "添加标签",
          //         // style: TextStyle(color: Colors.grey),
          //       ),
          //     ),
          //   ),
          // );
        })
      ],
    );
  }

  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, state) {
          return SimpleDialog(
            // contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10))),
            ),
            title: Stack(
              children: [
                Container(
                  child: InkWell(
                    child: Icon(Icons.close),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "编辑标签",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                    ),
                  ),
                )
              ],
            ),
            children: [
              SimpleDialogOption(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChangeNotifierProvider.value(
                      value: TagEditNotifier(tagSelectValues: []),
                      child: Consumer2<TagEditNotifier, TagsNotifier>(
                          builder: (context, tagEditNotifier, tagsNotifier, _) {
                        List<Tag> tags = tagsNotifier.getTags();
                        LogUtil.e(tags, tag: 'TagEditDialog');

                        List<Tag> test = tags +
                            tags +
                            tags +
                            tags +
                            tags +
                            tags +
                            tags +
                            tags +
                            tags;

                        return Column(
                          children: List.generate(
                              test.length,
                              (index) => InkWell(
                                    child: buildTagItem(
                                        tagEditNotifier.tagSelectValues
                                            .contains(test[index].id),
                                        test[index]),
                                    onTap: () {
                                      tagEditNotifier.isOnSelected(test[index]);
                                    },
                                  )),
                        );
                      }),
                    ),
                    addTagDialog(context),
                  ],
                ),
              ),
              SimpleDialogOption(
                child: InkWell(
                  onTap: () {},
                  child: Card(
                    elevation: 0,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.all(
                    //       Radius.circular(ScreenUtil().setWidth(10))),
                    // ),
                    color: Color(0xFFE8EAF6),
                    child: Container(
                      height: ScreenUtil().setHeight(37),
                      width: ScreenUtil().setHeight(133),
                      alignment: Alignment.center,
                      child: Text(
                        "删除标签",
                        // style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      });
}

class TagEditDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          height: 200,
          width: 300,
          color: Colors.blueGrey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(13)),
                    child: Container(
                      child: InkWell(
                        child: Icon(Icons.close),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(103),
                  ),
                  Container(
                    child: Text(
                      "编辑标签",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(18),
                      ),
                    ),
                  )
                ],
              ),
              ChangeNotifierProvider.value(
                value: TagEditNotifier(tagSelectValues: []),
                child: Consumer2<TagEditNotifier, TagsNotifier>(
                    builder: (context, tagEditNotifier, tagsNotifier, _) {
                  List<Tag> tags = tagsNotifier.getTags();
                  LogUtil.e(tags, tag: 'TagEditDialog');

                  return Column(
                    children: List.generate(
                        tags.length,
                        (index) => FilterChip(
                            checkmarkColor: Colors.white,
                            disabledColor: Colors.white,
                            label: Text(tags[index].title,
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            backgroundColor: vColorMap['icon'],
                            selectedColor: vColorMap['icon'],
                            selected: tagEditNotifier.tagSelectValues
                                .contains(tags[index].id),
                            onSelected: (value) {
                              // task.tagIds.add(tags[index].id);
                              tagEditNotifier.isOnSelected(tags[index]);
                            })),
                  );
                }),
              ),
            ],
          )),
    );
  }
}

Widget tagEdit({
  BuildContext context,
  @required Task task,
}) {
  return ChangeNotifierProvider.value(
    value: TagEditNotifier(tagSelectValues: task.tagIds),
    child: Consumer2<TagEditNotifier, TagsNotifier>(
        builder: (context, tagEditNotifier, tagsNotifier, _) {
      List<Tag> tags = tagsNotifier.getTags();
      LogUtil.e(tags, tag: 'TagEdit');

      return Wrap(
        spacing: 8.0,
        runSpacing: 0.0,
        children: List.generate(
            tags.length,
            (index) => FilterChip(
                checkmarkColor: Colors.white,
                disabledColor: Colors.white,
                label: Text(tags[index].title,
                    style: TextStyle(
                      color: Colors.white,
                    )),
                backgroundColor: vColorMap['icon'],
                selectedColor: vColorMap['icon'],
                selected:
                    tagEditNotifier.tagSelectValues.contains(tags[index].id),
                onSelected: (value) {
                  // task.tagIds.add(tags[index].id);
                  tagEditNotifier.isOnSelected(tags[index]);
                })),
      );
    }),
  );
}

Widget addTag({
  TextEditingController textEditingController,
  List<Tag> tags,
}) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          controller: textEditingController,
          // autofocus: true,
          style: TextStyle(fontSize: ScreenUtil().setSp(18)),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 1),
            hintText: '标签名称',
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
            tags.add(Tag(title: textEditingController.value.text));
          }),
    ],
  );
}
