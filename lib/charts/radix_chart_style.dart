import 'package:flutter/material.dart';

class RadixChartStyle {
  final double pointRounding;
  final double rotation;
  final double squash;
  final List<BoxShadow> shadows;
  final BorderSide side;
  final Color? color;
  final Gradient? gradient;

  const RadixChartStyle({
    this.pointRounding = 0,
    this.rotation = 0,
    this.squash = 0,
    this.side = const BorderSide(style: BorderStyle.none),
    this.shadows = const <BoxShadow>[],
    this.color,
    this.gradient
  }) : assert(!(color != null && gradient != null));
}