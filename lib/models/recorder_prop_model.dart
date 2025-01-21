
import 'package:flutter/widgets.dart';

class RecorderPropModel {
  RecorderPropModel({
    required this.actionBtnIcon,
    required this.durationTextColor,
    required this.actionTextColor,
    required this.recorderLabel,
    required this.iconSize,
  });

  final IconData actionBtnIcon;
  final Color durationTextColor;
  final Color actionTextColor;
  final String recorderLabel;
  final double iconSize;
}
