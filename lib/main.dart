import 'package:flutter/material.dart' hide StarBorder;
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
                child: DecoratedBox(
                    decoration: ShapeDecoration(
                        gradient: RadialGradient(colors: [
                          Colors.transparent,
                          Colors.blue.withOpacity(0.5),
                          Colors.blue
                        ], stops: [0, 0.8, 1]),
                        shape: PolygonBorder(
                            side: BorderSide(width: 2, color: Colors.blue),
                            pointRounding: 0.3,
                            relativeRadiusList: [
                              0.6,
                              0.3,
                              0.4,
                              0.6,
                              0.7,
                              0.8
                            ]))))
          ]),
        ),
      )),
    );
  }
}
