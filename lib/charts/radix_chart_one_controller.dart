import 'package:flutter/material.dart';
import 'package:radix_chart/charts/radix_chart_style.dart';

class RadixChartOneController extends ChangeNotifier {
  bool isHighlight;
  bool isHidden;
  List<double> relativeData;
  RadixChartStyle style;

  RadixChartOneController(
      {this.isHighlight = false,
      this.isHidden = false,
      required this.relativeData,
      this.style = const RadixChartStyle()});

  void toggleHighlight() {
    isHighlight = !isHighlight;
    if (isHighlight) isHidden = false;
    notifyListeners();
  }

  void setHighlight(bool b) {
    isHighlight = b;
    if (isHighlight) isHidden = false;
    notifyListeners();
  }

  void toggleHidden() {
    isHidden = !isHidden;
    if (isHidden) isHighlight = false;
    notifyListeners();
  }

  void setHidden(bool b) {
    isHidden = b;
    if (isHidden) isHighlight = false;
    notifyListeners();
  }
}
