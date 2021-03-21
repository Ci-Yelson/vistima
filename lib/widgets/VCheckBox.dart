import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget VCheckBox({@required bool isSelected, double size}) {
  return Container(
    width: size ?? 24,
    height: size ?? 24,
    child: FittedBox(
      child: CircularCheckBox(
        disabledColor: Color(0xFF8C9EFF),
        value: isSelected,
        onChanged: null,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
  );
}
