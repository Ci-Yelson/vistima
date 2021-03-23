import 'package:flutter/material.dart';

class ChartNotifier extends ChangeNotifier {
  DateTime startTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  DateTime endTime = DateTime.now();

  String selectedTask = '未选中';
  double selectedTimeCost = 0;

  bool isUseExample = false;

  changeStartTime(DateTime dateTime) {
    startTime = dateTime;
    notifyListeners();
  }

  changeEndTime(DateTime dateTime) {
    endTime = dateTime;
    notifyListeners();
  }

  changeSelctedTask(String string) {
    selectedTask = string;
    notifyListeners();
  }

  changeSelctedTimeCost(double s) {
    selectedTimeCost = s;
    notifyListeners();
  }

  initSelcted() {
    selectedTask = '未选中';
    selectedTimeCost = 0;
    notifyListeners();
  }

  changeIsUseExample() {
    isUseExample = !isUseExample;
    selectedTask = '未选中';
    selectedTimeCost = 0;
    notifyListeners();
  }
}
