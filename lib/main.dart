import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/config.dart';
import 'package:vistima_00/model/SQLHelper.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/0_HomePage/HomePage.dart';
import 'package:vistima_00/pages/1_TodoPage/TodoPage.dart';
import 'package:vistima_00/pages/2_TaskListPage/TaskListPage.dart';
import 'package:vistima_00/pages/3_UserPage/UserPage.dart';
import 'package:vistima_00/viewmodel/startViewModel.dart';
import 'package:vistima_00/widgets/VBottomAppBar.dart';
import 'package:vistima_00/widgets/VFloatingActionButton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SQLHelper.initialTest();

  runApp(MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Config.init(
      context: context,
      child: ScreenUtilInit(
          designSize: Size(375, 812),
          allowFontScaling: false,
          builder: () => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Vistima_00',
                theme: ThemeData(
                    //设置分隔符颜色为透明
                    dividerColor: Colors.transparent,
                    primaryColor: Colors.white,
                    // 设置路由进出动画
                    pageTransitionsTheme: PageTransitionsTheme(
                      builders: <TargetPlatform, PageTransitionsBuilder>{
                        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                        TargetPlatform.android: ZoomPageTransitionsBuilder(),
                      },
                    )),
                home: MyHomePage(),
              )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageController = PageController(initialPage: 0);
  int _pageIndex = 0;

  List<Widget> _getList() {
    return [HomePage(), TodoPage(), TaskListPage(), UserPage()];
  }

  //点击BottomItem跳转页面
  void _onTap(int index) {
    _pageController.jumpToPage(index);
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 100), curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pageList = _getList();
    return Scaffold(
      // backgroundColor: Colors.grey,
      //*显示页面
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //?状态栏背景颜色
          Container(
            height: ScreenUtil().setHeight(25),
            color: Colors.transparent,
          ),
          Container(
            height: MediaQuery.of(context).size.height -
                ScreenUtil().setHeight(25) -
                ScreenUtil().setHeight(66),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() {
                _pageIndex = index;
              }),
              itemBuilder: (BuildContext context, int index) {
                return _pageList[index];
              },
              itemCount: 4,
            ),
          ),
        ],
      ),
      //*FAB开始按钮
      floatingActionButton: _pageIndex == 0
          ? Consumer<StartNotifier>(
              builder: (context, startNotifier, _) {
                //*
                int startType = 2;
                if (startNotifier.getTodo().id != null) {
                  startType = 1;
                } else if (startNotifier.getTodo().tagIds != null &&
                    startNotifier.getTodo().tagIds.length != 0) {
                  startType = 0;
                }

                return VFloatingActionButton(
                    context, _pageIndex, startNotifier.getTodo(), startType);
              },
            )
          : VFloatingActionButton(
              context, _pageIndex, Todo(title: '无标题', tagIds: []), 2),
      //*FAB与BottomAppBar的镶嵌形式
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //*底部导航栏
      bottomNavigationBar: VBottomAppBar(
        onTap: _onTap,
        pageIndex: _pageIndex,
      ),
    );
  }
}
