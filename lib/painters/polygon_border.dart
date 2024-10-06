// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// @docImport 'package:flutter/material.dart';
library;

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../generators/polygon_generator.dart';

// Conversion from radians to degrees.
const double _kRadToDeg = 180 / math.pi;
// Conversion from degrees to radians.
const double _kDegToRad = math.pi / 180;

/// Copy of [StarBorder] with some modification
class PolygonBorder extends OutlinedBorder {
  /// Create a const star-shaped border with the given number [points] on the
  /// star.
  PolygonBorder({
    super.side,
    int? vertices,
    double relativeRadius = 1,
    List<double>? relativeRadiusList,
    this.pointRounding = 0,
    double rotation = 0,
    this.squash = 0,
  })  : assert(squash >= 0),
        assert(squash <= 1),
        assert(pointRounding >= 0),
        assert(pointRounding <= 1),
        assert((vertices == null && relativeRadiusList != null) || (vertices != null && relativeRadiusList == null)),
        assert(relativeRadiusList != null || (vertices != null && vertices >= 2 && 0 <= relativeRadius && relativeRadius <= 1)),
        _rotationRadians = rotation * _kDegToRad,
        points = vertices?.toDouble() ?? relativeRadiusList!.length.toDouble(),
        relativeRadiusList = relativeRadiusList ?? List.generate(vertices!, (i) => relativeRadius);

  final List<double> relativeRadiusList;
  
  /// The number of points in this star, or sides on a polygon.
  ///
  /// This is a floating point number: if this is not a whole number, then an
  /// additional star point or corner shorter than the others will be added to
  /// finish the shape. Only whole-numbered values will yield a symmetric shape.
  /// (This enables the number of points to be animated smoothly.)
  ///
  /// For stars created with [PolygonBorder], this is the number of points on
  /// the star. For polygons created with [StarBorder.polygon], this is the
  /// number of sides on the polygon.
  ///
  /// Must be greater than or equal to two.
  final double points;

  /// The ratio of the inner radius of a star with the outer radius.
  ///
  /// When making a star using [PolygonBorder], this is the ratio of the inner
  /// radius that to the outer radius. If it is one, then the inner radius
  /// will equal the outer radius.
  ///
  /// For polygons created with [StarBorder.polygon], getting this value will
  /// return the incircle radius of the polygon (the radius of a circle
  /// inscribed inside the polygon).
  ///
  /// Defaults to 0.4 for stars, and must be between zero and one, inclusive.
  double get innerRadiusRatio {
    // Polygons are just a special case of a star where the inner radius is the
    // incircle radius of the polygon (the radius of an inscribed circle).
    return _innerRadiusRatio ?? math.cos(math.pi / points);
  }

  final double? _innerRadiusRatio = null;

  /// The amount of rounding on the points of stars, or the corners of polygons.
  ///
  /// This is a value between zero and one which describes how rounded the point
  /// or corner should be. A value of zero means no rounding (sharp corners),
  /// and a value of one means that the entire point or corner is a portion of a
  /// circle.
  ///
  /// Defaults to zero. The sum of [pointRounding] and [valleyRounding] must be
  /// less than or equal to one.
  final double pointRounding;

  /// The amount of rounding of the interior corners of stars.
  ///
  /// This is a value between zero and one which describes how rounded the inner
  /// corners in a star (the "valley" between points) should be. A value of zero
  /// means no rounding (sharp corners), and a value of one means that the
  /// entire corner is a portion of a circle.
  ///
  /// Defaults to zero. The sum of [pointRounding] and [valleyRounding] must be
  /// less than or equal to one. For polygons created with [StarBorder.polygon],
  /// this will always be zero.
  final double valleyRounding = 0;

  /// The rotation in clockwise degrees around the center of the shape.
  ///
  /// The rotation occurs before the [squash] effect is applied, so that you can
  /// fine tune where the points of a star or corners of a polygon start.
  ///
  /// Defaults to zero, meaning that the first point or corner is pointing up.
  double get rotation => _rotationRadians * _kRadToDeg;
  final double _rotationRadians;

  /// How much of the aspect ratio of the attached widget to take on.
  ///
  /// If [squash] is non-zero, the border will match the aspect ratio of the
  /// bounding box of the widget that it is attached to, which can give a
  /// squashed appearance.
  ///
  /// The [squash] parameter lets you control how much of that aspect ratio this
  /// border takes on.
  ///
  /// A value of zero means that the border will be drawn with a square aspect
  /// ratio at the size of the shortest side of the bounding rectangle, ignoring
  /// the aspect ratio of the widget, and a value of one means it will be drawn
  /// with the aspect ratio of the widget. The value of [squash] has no effect
  /// if the widget is square to begin with.
  ///
  /// Defaults to zero, and must be between zero and one, inclusive.
  final double squash;

  @override
  ShapeBorder scale(double t) {
    return PolygonBorder(
      relativeRadiusList: relativeRadiusList,
      side: side.scale(t),
      rotation: rotation,
      pointRounding: pointRounding,
      squash: squash,
    );
  }

  
  @override
  PolygonBorder copyWith({
    BorderSide? side,
    List<double>? relativeRadius,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return PolygonBorder(
      side: side ?? this.side,
      relativeRadiusList: relativeRadius ?? relativeRadiusList,
      rotation: rotation ?? this.rotation,
      pointRounding: pointRounding ?? this.pointRounding,
      squash: squash ?? this.squash,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final Rect adjustedRect = rect.deflate(side.strokeInset);
    return PolygonGenerator(
      points: points,
      rotation: _rotationRadians,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      relativeRadius: relativeRadiusList,
      squash: squash,
    ).generate(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return PolygonGenerator(
      points: points,
      rotation: _rotationRadians,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      squash: squash,
      relativeRadius: relativeRadiusList
    ).generate(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final Rect adjustedRect = rect.inflate(side.strokeOffset / 2);
        final generator = PolygonGenerator(
          points: points,
          rotation: _rotationRadians,
          innerRadiusRatio: innerRadiusRatio,
          pointRounding: pointRounding,
          relativeRadius: relativeRadiusList,
          squash: squash,
        );
        final Path path = generator.generate(adjustedRect);
        canvas.drawPath(path, side.toPaint());
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PolygonBorder
        && other.side == side
        && other.points == points
        && other._innerRadiusRatio == _innerRadiusRatio
        && other.pointRounding == pointRounding
        && ListEquality().equals(other.relativeRadiusList, relativeRadiusList)
        && other.valleyRounding == valleyRounding
        && other._rotationRadians == _rotationRadians
        && other.squash == squash;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'StarBorder')}($side, points: $points, innerRadiusRatio: $innerRadiusRatio)';
  }
}