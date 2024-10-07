import 'package:flutter/material.dart';
import 'package:radix_chart/charts/radix_chart_one.dart';
import 'package:radix_chart/charts/radix_chart_style.dart';
import 'package:radix_chart/painters/graph_plane_painter.dart';
import 'package:radix_chart/charts/radix_chart.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: RadixChart(
        data: [
          [0.2, 0.4, 0.7, 0.3, 0.2, 0.6],
          [1.2, 0.3, 0.2, 1.3, 2.3, 1.4]
        ],
        pointRounding: 0.3,
      ))),
    );
  }
}
