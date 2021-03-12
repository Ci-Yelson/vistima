import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/pages/0_HomePage/TagSheet.dart';
import 'package:vistima_00/widgets/TimerWidget.dart';
import 'package:vistima_00/pages/0_HomePage/TodoSheet.dart';
import 'package:vistima_00/utils.dart';
import 'package:vistima_00/viewmodel/startViewModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var timeymd = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  var timehns = formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.only(left: pageMagrin, right: pageMagrin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*P1
              SizedBox(
                height: ScreenUtil().setHeight(17),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        // color: Colors.red,
                        child: Image.asset("assets/icons/boltfill.png"),
                        width: ScreenUtil().setWidth(32),
                        height: ScreenUtil().setHeight(32),
                      ),
                      Container(
                        child: Text(
                          "快速开始",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(35),
                              color: vColorMap['subText'],
                              fontFamily: textfont),
                        ),
                      ),
                    ],
                  ),
                  TimerWidget(),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(18),
              ),
              //*P2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //*Todo
                  Container(width: todoSheetWidth, child: todoColumn()),
                  SizedBox(
                    width: sheetGapWidth,
                  ),
                  //*Tag
                  Container(
                    width: tagSheetWidth,
                    child: tagColumn(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget todoColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //*P1
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "待办事项",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                      color: vColorMap['mainText'],
                      fontWeight: FontWeight.w600,
                      fontFamily: textfont),
                ),
              ),
              Expanded(
                  child: Container(
                width: 1,
              )),
              Container(
                child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/icons/名称顺序.png',
                      width: ScreenUtil().setWidth(28),
                      height: ScreenUtil().setHeight(28),
                    )),
              )
            ],
          ),
        ),
        //*P2
        TodoSheet(),
      ],
    );
  }

  Widget tagColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //*P1
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "标签",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                      color: vColorMap['mainText'],
                      fontWeight: FontWeight.w600,
                      fontFamily: textfont),
                ),
              ),
              Expanded(
                child: Container(
                  width: 1,
                ),
              ),
              Container(
                child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/icons/edit.png',
                      width: ScreenUtil().setWidth(28),
                      height: ScreenUtil().setHeight(28),
                    )),
              )
            ],
          ),
        ),
        //*P2
        TagSheet(),
      ],
    );
  }
}
