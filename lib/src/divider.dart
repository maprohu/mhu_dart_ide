import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen.dart';

import 'widgets/boxed.dart';

Widget rowWithDividers({
  required Iterable<Widget> children,
  required double? dividerThickness,
}) {
  if (dividerThickness == null) {
    return Row(
      children: children.toList(),
    );
  } else {
    return Row(
      children: children
          .separatedBy(
            VerticalDivider(
              width: dividerThickness,
              thickness: dividerThickness,
              indent: 0,
              endIndent: 0,
            ),
          )
          .toList(),
    );
  }
}

Widget columnWithDividers({
  required Iterable<Widget> children,
  required double? dividerThickness,
}) {
  if (dividerThickness == null) {
    return Column(
      children: children.toList(),
    );
  } else {
    return Column(
      children: children
          .separatedBy(
            Divider(
              height: dividerThickness,
              thickness: dividerThickness,
              indent: 0,
              endIndent: 0,
            ),
          )
          .toList(),
    );
  }
}

extension DividerSizedBits on SizedShaftBuilderBits {
  Bx horizontalDivider(double thickness) {
    return Bx.horizontalDivider(
      thickness: thickness,
      width: width,
    );
  }
}
