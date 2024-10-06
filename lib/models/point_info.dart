import 'package:flutter/material.dart';

class PointInfo {
  PointInfo({
    required this.valley,
    required this.point,
    required this.valleyArc1,
    required this.pointArc1,
    required this.valleyArc2,
    required this.pointArc2,
  });

  Offset valley;
  Offset point;
  Offset valleyArc1;
  Offset pointArc1;
  Offset pointArc2;
  Offset valleyArc2;
}