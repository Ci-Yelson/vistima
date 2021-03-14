import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';

class ChipNotifier extends ChangeNotifier {
  List<dynamic> tagSelectValues;

  ChipNotifier({this.tagSelectValues});

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

Widget tagEdit({
  BuildContext context,
  @required Task task,
}) {
  return ChangeNotifierProvider.value(
    value: ChipNotifier(tagSelectValues: task.tagIds),
    child: Consumer2<ChipNotifier, TagsNotifier>(
        builder: (context, chipNotifier, tagsNotifier, _) {
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
                selected: chipNotifier.tagSelectValues.contains(tags[index].id),
                onSelected: (value) {
                  // task.tagIds.add(tags[index].id);
                  chipNotifier.isOnSelected(tags[index]);
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
