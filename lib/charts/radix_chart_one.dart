import 'dart:math';

import 'package:flutter/material.dart';
import 'package:radix_chart/charts/radix_chart_style.dart';
import 'package:radix_chart/painters/polygon_border.dart';

class RadixChartOne extends StatelessWidget {
  final List<double> data;
  final List<double> maxData;
  final RadixChartStyle style;
  final Function()? onClick;

  RadixChartOne({required this.data, required this.maxData, this.style = const RadixChartStyle(), this.onClick});

  get _relativeData {
    return List.generate(data.length, (i) => data[i] / maxData[i]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: ShapeDecoration(
        color: style.color,
        gradient: style.gradient,
        shadows: style.shadows,
        shape: PolygonBorder(
        side: style.side,
        pointRounding: style.pointRounding,
        squash: style.squash,
        rotation: style.rotation,
        relativeRadiusList: _relativeData
      )),
    )
    );
  }
}