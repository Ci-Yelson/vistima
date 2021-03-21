import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/viewmodel/tagViewModel.dart';

//*tagWrap
Widget tagWrap(
    {BuildContext context,
    @required List<dynamic> tagIds,
    @required Color backGroundColor,
    bool showEdit = false,
    Color editIconColor,
    Function ontap}) {
  return Consumer<TagsNotifier>(builder: (context, tagsNotifier, _) {
    List<Tag> tags = [];

    for (var id in tagIds) {
      // //*Test
      // for (var i = 0; i < 10; i++) {
      //   tags.add(tagsNotifier.getTags().firstWhere((t) => t.id == id));
      // }
      tags.add(tagsNotifier.getTags().firstWhere((t) => t.id == id));
    }

    return Wrap(
      children: [
        Wrap(
          children: (tags.isNotEmpty
                  ? List.generate(
                      tags.length,
                      (i) => sizedTagChip(
                            Text(
                              tags[i].title,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14),
                                  color: Colors.white),
                            ),
                            backGroundColor,
                          ))
                  : [
                      sizedTagChip(
                        Text(
                          "无",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.white),
                        ),
                        // Colors.grey.withAlpha(150),
                        backGroundColor,
                      )
                    ]) +
              [
                showEdit
                    ? InkWell(
                        child: sizedTagChip(
                            Icon(
                              Icons.edit,
                              color: editIconColor ?? Colors.black,
                              size: ScreenUtil().setSp(20),
                            ),
                            backGroundColor),
                        onTap: ontap,
                      )
                    : Container()
              ],
        ),
      ],
    );
  });
}

Widget sizedTagChip(Widget text, Color backGroundColor) {
  return Card(
    elevation: 0,
    color: backGroundColor,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14.0))), //设置圆角
    child: Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(2),
          bottom: ScreenUtil().setHeight(2),
          left: ScreenUtil().setWidth(8),
          right: ScreenUtil().setWidth(8)),
      child: text,
    ),
  );
}
