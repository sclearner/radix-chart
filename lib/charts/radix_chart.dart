import 'dart:math';

import 'package:flutter/material.dart';
import 'package:radix_chart/charts/radix_chart_controller.dart';
import 'package:radix_chart/charts/radix_chart_one.dart';
import 'package:radix_chart/charts/radix_chart_one_controller.dart';
import 'package:radix_chart/charts/radix_chart_style.dart';
import 'package:radix_chart/painters/graph_plane_painter.dart';

class RadixChart extends StatefulWidget {
  //Size
  final double height;
  final double width;
  final int _vertices;

  //Format
  final double pointRounding;
  final double rotation;
  final double squash;

  //Axis format
  final double minRelativeRadius;
  final double maxRelativeRadius;
  final int axisLines;
  final BorderSide axisSide;

  /// A 2D data board
  final List<List<double>> data;

  RadixChart(
      {super.key,
      this.height = double.infinity,
      this.width = double.infinity,
      required this.data,
      this.pointRounding = 0,
      this.rotation = 0,
      this.squash = 0,
      this.minRelativeRadius = 0.0001,
      this.maxRelativeRadius = 1,
      this.axisLines = 5,
      this.axisSide = const BorderSide()})
      : assert(data.isNotEmpty),
        assert(data[0].length >= 2),
        assert(data.every((r) => r.length == data[0].length)),
        _vertices = data[0].length;

  @override
  State<RadixChart> createState() => _RadixChartState();
}

class _RadixChartState extends State<RadixChart> {
  late List<List<double>> relativeData;
  late List<Widget> charts;
  late final List<RadixChartOneController> _radix_chart_one_controllers;

  late final RadixChartController _controller;

  @override
  void initState() {
    super.initState();
    relativeData = updateRelativeData();
    print(relativeData);
    _radix_chart_one_controllers = [for (int i = 0; i < widget.data.length; i++) RadixChartOneController(relativeData: relativeData[i])];
    _controller = RadixChartController();
    _controller.controllers = _radix_chart_one_controllers;
    charts = [for (int i = 0; i < widget.data.length; i++) generateChart(i)];
  }

  @override
  void didUpdateWidget(covariant RadixChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      relativeData = updateRelativeData();
      setState(() {});
    }
  }

  List<List<double>> updateRelativeData() {
    final result = List<List<double>>.generate(
        widget.data.length, (i) => List<double>.filled(widget._vertices, 1));
    for (int i = 0; i < widget._vertices; i++) {
      double maxCol = List.generate(widget.data.length, (j) => widget.data[j][i]).reduce(max);
      for (int j = 0; j < widget.data.length; j++) {
        result[j][i] = widget.data[j][i] / maxCol;
      }
    }
    return result;
  }

  Widget generatedAxis() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: GraphPlanePainter(
            vertices: widget._vertices,
            pointRounding: widget.pointRounding,
            squash: widget.squash,
            minRelativeRadius: widget.minRelativeRadius,
            maxRelativeRadius: widget.maxRelativeRadius,
            lines: widget.axisLines,
            side: widget.axisSide),
      ),
    );
  }

  Widget generateChart(int index) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: RadixChartOne(
            controller: _radix_chart_one_controllers[index],
            relativeData: relativeData[index],
            onClick: () {
              _controller.setHighlight(index);
            },
            style: RadixChartStyle(
                side: BorderSide(width: 2),
                highlightSide: BorderSide(color: Colors.blue),
                pointRounding: widget.pointRounding,
                squash: widget.squash,
                rotation: widget.rotation)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          generatedAxis(),
          ...charts
        ],
      ),
    );
  }
}
