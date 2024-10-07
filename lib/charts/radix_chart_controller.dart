import 'package:flutter/material.dart';
import 'package:radix_chart/charts/radix_chart_one_controller.dart';

class RadixChartController extends ChangeNotifier {
  int? hightlightedIndex;
  late List<RadixChartOneController> controllers;
  
  void setHighlight(int i) {
    if (hightlightedIndex != null) controllers[hightlightedIndex!].setHidden(true);
    hightlightedIndex = i;
    controllers[i].setHighlight(true);
    notifyListeners();
  }

  void turnHighlightOff() {
    hightlightedIndex = null;
    for (final c in controllers) {
      c.setHidden(false);
      c.setHighlight(false);
    }
    notifyListeners();
  }
}