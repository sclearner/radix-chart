import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:radix_chart/generators/polygon_generator.dart';


// Conversion from radians to degrees.
const double _kRadToDeg = 180 / math.pi;
// Conversion from degrees to radians.
const double _kDegToRad = math.pi / 180;

class PolygonPainter extends CustomPainter {
PolygonPainter({
    this.side = const BorderSide(style: BorderStyle.none),
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

  final BorderSide side;

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
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    final path = PolygonGenerator(
      points: points,
      rotation: _rotationRadians,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      squash: squash,
      relativeRadius: relativeRadiusList
    ).generate(Rect.fromCenter(center: Offset(w/2, h/2), width: w, height: h));
    if (side.style == BorderStyle.solid) canvas.drawPath(path, side.toPaint());
  }

  @override
  bool shouldRepaint(covariant PolygonPainter oldDelegate) {
    return oldDelegate.points != points 
        || oldDelegate.pointRounding != pointRounding 
        || const ListEquality().equals(oldDelegate.relativeRadiusList, relativeRadiusList);
  }
  
}