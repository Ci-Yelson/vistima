import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/3_UserPage/charts/ChartNotifier.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';

class DataType {
  final String tasktitle;
  final double timeCost;
  final Duration t;
  final String color;

  DataType(this.tasktitle, this.timeCost, {this.color, this.t});
}

// List<Color> colorList = [
//   Color(0xffaddfdd),
//   Color(0xfff5c8cf),
//   Color(0xfff6e5e9),
//   Color(0xffdef2ef),
//   Color(0xff8C9EFF),
// ];

List<Color> colorList = [
  Color(0xff9fa8da),
  Color(0xff8c9eff),
  Color(0xff3f51b5),
  Color(0xffdef2ef),
  Color(0xffdef2ef),
];

enum ChartType { pie, bar }

class ChartsWidget extends StatefulWidget {
  final TasksNotifier tasksNotifier;
  final ChartNotifier chartNotifier;
  final ChartType chartType;
  final double chartSzie;
  final DateTime dateTime;
  final bool isUseExample;

  ChartsWidget(
      {@required this.tasksNotifier,
      @required this.chartNotifier,
      @required this.chartType,
      @required this.chartSzie,
      @required this.dateTime,
      this.isUseExample = false});

  @override
  _ChartsWidgetState createState() => _ChartsWidgetState();
}

class _ChartsWidgetState extends State<ChartsWidget> {
  String tip;
  bool animate = true;

  List<DataType> randomData = [];

  _onSelected(charts.SelectionModel model) {
    animate = false;

    if (model.selectedDatum.first.datum.tasktitle != '无') {
      widget.chartNotifier
          .changeSelctedTask(model.selectedDatum.first.datum.tasktitle);
      // ! BUG
      widget.chartNotifier
          .changeSelctedTimeCost(model.selectedDatum.first.datum.timeCost);
    } else {
      widget.chartNotifier
          .changeSelctedTask(model.selectedDatum.first.datum.tasktitle);
    }
  }

  _getTip() {
    List<Task> _tasks = widget.tasksNotifier.tasksInDate(widget.dateTime);
    if (_tasks.isNotEmpty && _tasks.length > 1) {
      int max;
      for (var i = 0; i < _tasks.length; i++) {
        for (var j = i + 1; j < _tasks.length; j++) {
          if (_tasks[i].timeCost.inSeconds > _tasks[j].timeCost.inSeconds) {
            max = i;
          } else {
            max = j;
          }
        }
      }
      Duration t = _tasks[max].timeCost;
      if (t.inSeconds <= 120) {
        setState(() {
          tip = 'seconds';
        });
      } else if (t.inMinutes <= 60) {
        setState(() {
          tip = 'minutes';
        });
      } else {
        setState(() {
          tip = 'hours';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getTip();

    //*随机数据
    final random = Random();

    randomData = [
      DataType('事件1', random.nextDouble() * 100),
      DataType('事件2', random.nextDouble() * 100),
      DataType('事件3', random.nextDouble() * 100),
      DataType('事件4', random.nextDouble() * 100),
      DataType('事件5', random.nextDouble() * 100),
    ];
  }

  // ! 获取图表所需要的显示数据
  List<charts.Series<DataType, String>> _getData() {
    //*获取任务数据
    List<Task> _tasks = widget.tasksNotifier.tasksInDate(widget.dateTime);

    if (_tasks.isNotEmpty) {
      final data = List.generate(_tasks.length, (index) {
        String _title = _tasks[index].title;
        // if (_title.length > 4) {
        //   _title = _title.substring(0, 4) + '...';
        // }
        print('>>>_task.color:${_tasks[index].color}');

        if (tip == 'seconds') {
          return DataType(_title, _tasks[index].timeCost.inSeconds.toDouble(),
              color: _tasks[index].color);
        } else if (tip == 'minutes') {
          return DataType(_title, _tasks[index].timeCost.inMinutes.toDouble(),
              color: _tasks[index].color);
        } else if (tip == 'hours') {
          return DataType(_title, _tasks[index].timeCost.inHours.toDouble(),
              color: _tasks[index].color);
        }
        return DataType(_title, _tasks[index].timeCost.inSeconds.toDouble(),
            color: _tasks[index].color);
      });

      return [
        charts.Series<DataType, String>(
          id: 'TimeCost',
          // ! 定义当前数据的柱状图颜色
          colorFn: (task, index) {
            // return widget.isUseExample
            //     ? charts.ColorUtil.fromDartColor(colorList[index])
            //     : charts.ColorUtil.fromDartColor(
            //         Color(int.tryParse(task.color)));
            return charts.ColorUtil.fromDartColor(colorList[index]);
          },
          domainFn: (DataType tasks, _) => tasks.tasktitle,
          measureFn: (DataType tasks, _) => tasks.timeCost,
          labelAccessorFn: (DataType row, _) =>
              // '${row.tasktitle}: ${row.timeCost.toInt()} $tip',
              '${row.tasktitle}',

          data: widget.isUseExample ? randomData : data,
        )
      ];
    } else {
      return [
        charts.Series<DataType, String>(
          id: 'TimeCost',
          // ! 定义当前数据的柱状图颜色
          colorFn: (_, index) {
            return widget.isUseExample
                ? charts.ColorUtil.fromDartColor(colorList[index])
                : charts.ColorUtil.fromDartColor(Colors.grey.withAlpha(100));
          },
          domainFn: (DataType tasks, _) => tasks.tasktitle,
          measureFn: (DataType tasks, _) => tasks.timeCost,
          labelAccessorFn: (DataType row, _) =>
              widget.chartType == ChartType.pie
                  ? widget.isUseExample
                      ? '${row.tasktitle}: ${row.timeCost.toInt()}'
                      : ''
                  : '${row.timeCost.toInt()}',
          data: widget.isUseExample
              ? randomData
              : [
                  DataType('无', 1),
                ],
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.chartType == ChartType.pie ? _pieChart() : _barChart();
  }

  Widget _pieChart() {
    return Container(
      width: widget.chartSzie,
      height: widget.chartSzie,
      // ! 饼状图表
      child: Stack(
        children: <Widget>[
          //Todo
          charts.PieChart(
            _getData(),
            animate: animate,
            defaultRenderer: charts.ArcRendererConfig(
                arcWidth: widget.chartSzie ~/ 5, // ! 设置中心圆的大小(值越大，圆越小)
                arcRendererDecorators: [
                  charts.ArcLabelDecorator(
                      insideLabelStyleSpec: charts.TextStyleSpec(
                        fontSize: widget.chartSzie ~/ 20,
                        color: charts.Color.white,
                        fontFamily: 'Zhanku Wenyi',
                        // fontWeight: 'bold',
                      ),
                      outsideLabelStyleSpec: charts.TextStyleSpec(
                        fontSize: widget.chartSzie ~/ 20,
                        color: charts.Color.black,
                        fontFamily: 'Zhanku Wenyi',
                        // fontWeight: 'bold',
                      ))
                ]),
            selectionModels: [
              charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelected,
              )
            ],
          ),
          Center(
            child: ClipOval(
              child: Container(
                height: (widget.chartSzie ~/ 5 * 2.3).toDouble(),
                width: (widget.chartSzie ~/ 5 * 2.3).toDouble(),
                color: Colors.white.withAlpha(70),
              ),
            ),
          ),
          Consumer<ChartNotifier>(builder: (context, chartNotifier, _) {
            double taskTimeCost = chartNotifier.selectedTimeCost;
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    // '${formatDate(DateTime.now(), [DD])}',
                    '${chartNotifier.selectedTask.length > 5 ? chartNotifier.selectedTask.substring(0, 5) + '...' : chartNotifier.selectedTask}',
                    style: TextStyle(
                      fontFamily: 'Zhanku Xiaowei',
                      fontSize: (widget.chartSzie ~/ 14).toDouble(),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "${(taskTimeCost ~/ 3600).toStringAsFixed(0)}",
                          style: TextStyle(
                              letterSpacing: 1.3,
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              ":${(taskTimeCost % 3600 ~/ 600).toStringAsFixed(0)}${((taskTimeCost % 600) ~/ 60).toStringAsFixed(0)}",
                          style: TextStyle(
                              letterSpacing: 1.3,
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              ":${(taskTimeCost % 60 ~/ 10).toStringAsFixed(0)}${(taskTimeCost % 10).toStringAsFixed(0)}",
                          style: TextStyle(
                              letterSpacing: 1.3,
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.black),
                        ),
                      ])),
                    ],
                  )
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _barChart() {
    return Container(
      height: widget.chartSzie,
      child: charts.BarChart(
        _getData(),
        selectionModels: [
          charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: _onSelected,
          )
        ],
      ),
    );
  }
}
