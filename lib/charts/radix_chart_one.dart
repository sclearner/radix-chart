import 'package:flutter/material.dart';
import 'package:radix_chart/charts/radix_chart_one_controller.dart';
import 'package:radix_chart/charts/radix_chart_style.dart';
import 'package:radix_chart/painters/polygon_border.dart';

class RadixChartOne extends StatefulWidget {
  final List<double> relativeData;
  final RadixChartStyle style;
  final Function()? onClick;
  final bool highlight;
  final bool hidden;
  final RadixChartOneController? controller;

  const RadixChartOne(
      {super.key,
      required this.relativeData,
      this.style = const RadixChartStyle(),
      this.onClick,
      this.highlight = false,
      this.hidden = false,
      this.controller});

  @override
  State<RadixChartOne> createState() => RadixChartOneState();
}

class RadixChartOneState extends State<RadixChartOne> {
  late final RadixChartOneController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        RadixChartOneController(
            isHighlight: widget.highlight,
            isHidden: widget.hidden,
            relativeData: widget.relativeData,
            style: widget.style);
    _controller.addListener(() {
      setState(() {});
    });
  }
  
  @override
  void didUpdateWidget(covariant RadixChartOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.relativeData = widget.relativeData; 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  get highlight => _controller.isHighlight;
  get hidden => _controller.isHidden;

  get currentSide {
    if (highlight) return _controller.style.highlightSide ?? _controller.style.side;
    if (hidden) return _controller.style.hiddenSide ?? _controller.style.side;
    return _controller.style.side;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onClick,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: ShapeDecoration(
              color: _controller.style.color,
              gradient: _controller.style.gradient,
              shadows: highlight ? _controller.style.shadows : null,
              shape: PolygonBorder(
                  side: currentSide,
                  pointRounding: _controller.style.pointRounding,
                  squash: _controller.style.squash,
                  rotation: _controller.style.rotation,
                  relativeRadiusList: _controller.relativeData)),
        ));
  }
}
