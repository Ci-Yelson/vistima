import 'dart:ui';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';
import 'package:vistima_00/viewmodel/todoViewModel.dart';
import 'package:vistima_00/widgets/VCheckBox.dart';

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

class TagEditDialog extends StatefulWidget {
  final bool editToTodo;
  final Todo todo;
  final bool editToTask;
  final Task task;
  final bool useBlur;

  const TagEditDialog({
    Key key,
    this.editToTodo = false,
    this.todo,
    this.editToTask = false,
    this.task,
    this.useBlur = false,
  }) : super(key: key);

  @override
  _TagEditDialogState createState() => _TagEditDialogState();
}

class _TagEditDialogState extends State<TagEditDialog> {
  @override
  Widget build(BuildContext context) {
    Color _color = widget.useBlur ? Colors.white : Colors.black;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: ScreenUtil().setHeight(600),
                width: ScreenUtil().setWidth(355),
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(50),
                    borderRadius: BorderRadius.circular((10.0))),
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(600),
              width: ScreenUtil().setWidth(355),
              decoration: BoxDecoration(
                  color: widget.useBlur
                      ? Colors.white.withAlpha(150)
                      : Colors.white,
                  borderRadius: BorderRadius.circular((10.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //*P1
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                    child: Stack(
                      children: [
                        Container(
                          child: InkWell(
                            child: Icon(
                              Icons.close,
                              color: _color,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "编辑标签",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              color: _color,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  //*P2
                  ChangeNotifierProvider.value(
                      value: TagEditNotifier(tagSelectValues: []),
                      child: Consumer4<TagEditNotifier, TagsNotifier,
                          TodosNotifier, TasksNotifier>(
                        builder: (context, tagEditNotifier, tagsNotifier,
                            todosNotifier, tasksNotifier, _) {
                          List<Tag> tags = tagsNotifier.getTags();
                          LogUtil.e(tags, tag: 'TagEditDialog');
                          // List<Tag> tags =
                          //     tags + tags + tags + tags + tags + tags + tags + tags + tags;

                          //*Task或Todo编辑标签-初始化已有标签
                          if (widget.editToTask == true) {
                            tagEditNotifier.tagSelectValues =
                                widget.task.tagIds;
                          } else if (widget.editToTodo == true) {
                            tagEditNotifier.tagSelectValues =
                                widget.todo.tagIds;
                          }

                          return Column(
                            children: [
                              Container(
                                height: ScreenUtil().setHeight(480),
                                child: ScrollConfiguration(
                                  behavior: NScrollBehavior(),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: pageMagrin,
                                            vertical: pageMagrin),
                                        child: Column(
                                          children: List.generate(
                                              tags.length,
                                              (index) => InkWell(
                                                    child: buildTagItem(
                                                        tagEditNotifier
                                                            .tagSelectValues
                                                            .contains(
                                                                tags[index].id),
                                                        tags[index],
                                                        _color),
                                                    onTap: () {
                                                      tagEditNotifier
                                                          .isOnSelected(
                                                              tags[index]);
                                                    },
                                                  )),
                                        ),
                                      ),
                                      Container(
                                          child: addTagDialog(
                                              context, tagsNotifier, _color)),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(15),
                                      0,
                                      ScreenUtil().setWidth(12),
                                      0,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: ScreenUtil().setHeight(10)),
                                    width: ScreenUtil().setWidth(133),
                                    child: InkWell(
                                      onTap: () {
                                        //!删除标签
                                        if (!widget.editToTask &&
                                            !widget.editToTodo) {
                                          for (var id in tagEditNotifier
                                              .tagSelectValues) {
                                            //*先清除todo和task所连接的tagId，然后再删除tag
                                            todosNotifier.updatetagId(
                                                oldIds: id);
                                            tasksNotifier.updatetagId(
                                                oldIds: id);
                                            tagsNotifier.delete(id);
                                          }
                                        } else {
                                          //*Task或Todo编辑标签-初始化已有标签

                                        }
                                      },
                                      child: Card(
                                        elevation: 0,
                                        color: widget.useBlur
                                            ? Colors.transparent
                                            : Color(0xFFE8EAF6),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  ScreenUtil().setHeight(8)),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "删除标签",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(17),
                                                color: _color),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: ScreenUtil().setHeight(10)),
                                    width: ScreenUtil().setWidth(180),
                                    child: InkWell(
                                      onTap: () {
                                        //!保存改动

                                        if (!widget.editToTask &&
                                            !widget.editToTodo) {
                                          Navigator.pop(context);
                                        } else {
                                          //*Task或Todo编辑标签-初始化已有标签
                                          //*考虑到开始任务计时时，Task还未赋予Id，故选择在外部更新
                                          if (widget.editToTask == true) {
                                            widget.task.tagIds =
                                                tagEditNotifier.tagSelectValues;
                                          } else if (widget.editToTodo ==
                                              true) {
                                            widget.todo.tagIds =
                                                tagEditNotifier.tagSelectValues;
                                          }
                                          // Navigator.pop(context, true);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Card(
                                        elevation: 0,
                                        color: widget.useBlur
                                            ? Colors.transparent
                                            : Color(0xFF8C9EFF),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  ScreenUtil().setHeight(8)),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "保存改动",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(17),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTagItem(bool isSelected, Tag tag, Color color) {
    return Container(
      height: ScreenUtil().setHeight(42),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: ScreenUtil().setWidth(10)),
          VCheckBox(isSelected: isSelected),
          SizedBox(
            width: ScreenUtil().setWidth(10),
          ),
          Container(
            child: Text(
              "${tag.title}",
              style: TextStyle(fontSize: ScreenUtil().setSp(20), color: color),
            ),
          )
        ],
      ),
    );
  }

  Widget addTagDialog(
      BuildContext context, TagsNotifier tagsNotifier, Color color) {
    final TextEditingController textEditingController = TextEditingController();
    FocusNode focusNode = FocusNode();

    return Row(
      children: [
        SizedBox(width: ScreenUtil().setWidth(20)),
        Expanded(
          child: TextField(
            focusNode: focusNode,
            controller: textEditingController,
            // autofocus: true,
            style: TextStyle(fontSize: ScreenUtil().setSp(18), color: color),
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
        InkWell(
            child: Container(
                child: Icon(
              Icons.add,
              color: color,
            )),
            onTap: () {
              //!添加标签
              if (textEditingController.value.text != null &&
                  textEditingController.value.text.length > 0) {
                tagsNotifier
                    .insert(Tag(title: textEditingController.value.text));
                focusNode.unfocus();
              }
            }),
        SizedBox(width: ScreenUtil().setWidth(10)),
      ],
    );
  }
}

//*去除ListView滑动水波纹
class NScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (getPlatform(context) == TargetPlatform.android ||
        getPlatform(context) == TargetPlatform.fuchsia) {
      return GlowingOverscrollIndicator(
        child: child,
        showLeading: false,
        showTrailing: false,
        axisDirection: axisDirection,
        color: Theme.of(context).accentColor,
      );
    } else {
      return child;
    }
  }
}
