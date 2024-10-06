import 'package:flutter/material.dart' hide StarBorder;
import 'package:radix_chart/charts/radix_chart_one.dart';
import 'package:radix_chart/charts/radix_chart_style.dart';
import 'package:radix_chart/painters/graph_plane_painter.dart';
import 'package:radix_chart/painters/polygon_border.dart';
import 'package:radix_chart/painters/polygon_painter.dart';

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
        child: Container(
          width: 300,
          height: 300,
          child: Stack(children: [
            Container(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: GraphPlanePainter(
                      vertices: 6,
                      side: BorderSide(color: Colors.grey),
                      minRelativeRadius: 0.2,
                      pointRounding: 0.3,
                      lines: 5),
                )),
            Container(
                width: 300,
                height: 300,
                child: RadixChartOne(
                  data: [1.2, 2.4, 3.4, 2.1, 2.5, 1.6],
                  maxData: [1.6, 2.8, 6.7, 3.4, 2.8, 2],
                  onClick: () {
                    print("A chart");
                  },
                  style: const RadixChartStyle(
                    side: BorderSide(color: Colors.blue, width: 2), 
                    pointRounding: 0.3, 
                    shadows: [BoxShadow(color: Colors.blue, blurRadius: 8, blurStyle: BlurStyle.outer)]
                    ),
                  )),
             Container(
                width: 300,
                height: 300,
                child: RadixChartOne(
                  data: [1.4, 2.3, 1.2, 1, 1, 1],
                  maxData: [1.6, 2.8, 6.7, 3.4, 2.8, 2],
                  onClick: () {
                    print("A chart");
                  },
                  style: const RadixChartStyle(
                    side: BorderSide(color: Colors.blue, width: 2), 
                    pointRounding: 0.3, 
                    shadows: [BoxShadow(color: Colors.blue, blurRadius: 8, blurStyle: BlurStyle.outer)]
                    ),
                  )),                  
          ]),
        ),
      )),
    );
  }
}
