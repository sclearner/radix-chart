import 'package:flutter/material.dart';

class RadixChartStyle {
  final double pointRounding;
  final double rotation;
  final double squash;
  final List<BoxShadow> shadows;
  final BorderSide? highlightSide;
  final BorderSide side;
  final BorderSide? hiddenSide;
  final Color? color;
  final Gradient? gradient;

  const RadixChartStyle({
    this.pointRounding = 0,
    this.rotation = 0,
    this.squash = 0,
    this.side = const BorderSide(style: BorderStyle.none),
    this.shadows = const <BoxShadow>[],
    this.color,
    this.gradient,
    this.hiddenSide,
    this.highlightSide
  }) : assert(!(color != null && gradient != null));

  @override
  bool operator==(Object other) {
    if (other is! RadixChartStyle) return false;
    return pointRounding == other.pointRounding ||
            rotation == other.rotation ||
            squash == other.squash ||
            highlightSide == other.highlightSide ||
            hiddenSide == other.hiddenSide ||
            color == other.color ||
            gradient == other.gradient ||
            shadows == other.shadows ||
            side == other.side;
  }

  @override
  int get hashCode => side.hashCode ^ shadows.hashCode;
}