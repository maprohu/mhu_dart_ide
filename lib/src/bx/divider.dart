import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../builder/sized.dart';
import 'boxed.dart';


extension DividerSizedBits on SizedShaftBuilderBits {
  Bx horizontalDivider(double thickness) {
    return horizontalDividerBx(
      thickness: thickness,
      width: width,
    );
  }
}

Bx rowWithDinidersBx({
  required List<Bx> columns,
  required double thickness,
  required double height,
  required Size size,
}) {
  final divider = Bx.leaf(
    size: Size(thickness, height),
    widget: VerticalDivider(
      width: thickness,
      thickness: thickness,
      indent: 0,
      endIndent: 0,
    ),
  );
  return Bx.row(
    columns: columns.separatedBy(divider).toList(),
    size: size,
  );
}

Bx columnWithDividersBx({
  required List<Bx> rows,
  required double thickness,
  required double width,
  required Size size,
}) {
  final divider = horizontalDividerBx(
    thickness: thickness,
    width: width,
  );
  return Bx.col(
    rows: rows.separatedBy(divider).toList(),
    size: size,
  );
}

Bx verticalDividerBx({
  required double thickness,
  required double height,
}) {
  return Bx.leaf(
    size: Size(thickness, height),
    widget: VerticalDivider(
      width: thickness,
      thickness: thickness,
      indent: 0,
      endIndent: 0,
    ),
  );
}

Bx horizontalDividerBx({
  required double thickness,
  required double width,
}) {
  return Bx.leaf(
    size: Size(width, thickness),
    widget: Divider(
      height: thickness,
      thickness: thickness,
      indent: 0,
      endIndent: 0,
    ),
  );
}