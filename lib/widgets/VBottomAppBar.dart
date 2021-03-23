import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vistima_00/const.dart';

class VBottomAppBar extends StatelessWidget {
  final int pageIndex;
  final Function onTap;
  final normalIconsMap = {
    "首页": "assets/icons/bottom_appbar/home.png",
    "Todo": "assets/icons/bottom_appbar/todo.png",
    "列表": "assets/icons/bottom_appbar/list.png",
    "用户": "assets/icons/bottom_appbar/user.png",
  };
  final activeIconsMap = {
    "首页": "assets/icons/bottom_appbar/homefill.png",
    "Todo": "assets/icons/bottom_appbar/todofill.png",
    "列表": "assets/icons/bottom_appbar/listfill.png",
    "用户": "assets/icons/bottom_appbar/userfill.png",
  };

  VBottomAppBar({this.pageIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10.0,
      // color: Colors.red,
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: normalIconsMap.keys
            .toList()
            .asMap()
            .keys
            .map((e) => _buildChild(e, context))
            .toList()
              ..insertAll(2, [
                SizedBox(
                  width: 30,
                )
              ]),
      ),
    );
  }

  //BottomItem样式
  Widget _buildChild(int e, BuildContext context) {
    bool isActive = (e == pageIndex);
    LogUtil.e({e, pageIndex}, tag: ">bottomItem");

    return Ink(
      height: iconItemHeight,
      width: iconItemHeight,
      decoration: BoxDecoration(
        //设置圆角
        borderRadius: BorderRadius.all(Radius.circular(60.0)),
      ),
      child: InkWell(
        onTap: () => onTap(e),
        borderRadius: BorderRadius.circular(60.0),
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              children: [
                Container(
                  height: iconSize,
                  width: iconSize,
                  child: Image.asset(
                    isActive
                        ? activeIconsMap[activeIconsMap.keys.toList()[e]]
                        : normalIconsMap[normalIconsMap.keys.toList()[e]],
                    // height: ScreenUtil().setHeight(30),
                    // width: ScreenUtil().setHeight(30),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
