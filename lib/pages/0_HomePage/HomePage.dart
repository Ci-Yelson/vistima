import 'package:animations/animations.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vistima_00/const.dart';
import 'package:vistima_00/pages/0_HomePage/TagEditDialog.dart';
import 'package:vistima_00/pages/0_HomePage/TagEditPage.dart';
import 'package:vistima_00/pages/0_HomePage/TagSheet.dart';
import 'package:vistima_00/widgets/TagEdit.dart';
import 'package:vistima_00/widgets/TimerWidget.dart';
import 'package:vistima_00/pages/0_HomePage/TodoSheet.dart';
import 'package:vistima_00/utils.dart';

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
                          "????????????",
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
                    child: tagColumn(context),
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
                  "????????????",
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
            ],
          ),
        ),
        //*P2
        TodoSheet(),
      ],
    );
  }

  Widget tagColumn(BuildContext context) {
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
                  "??????",
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
              InkWell(
                  child: Image.asset(
                    'assets/icons/edit.png',
                    width: ScreenUtil().setWidth(28),
                    height: ScreenUtil().setHeight(28),
                  ),
                  onTap: () => showDialog(
                      context: context, builder: (_) => TagEditDialog())),
            ],
          ),
        ),
        //*P2
        TagSheet(),
      ],
    );
  }
}
