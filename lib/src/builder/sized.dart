import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../app.dart';
import '../bx/padding.dart';
import '../bx/boxed.dart';
import '../config.dart';
import '../op.dart';
import '../screen/calc.dart';
import 'double.dart';
import 'shaft.dart';

part 'sized.g.compose.dart';

typedef SizedBuilder = Bx Function(SizedShaftBuilderBits sizedBits);

@Compose()
abstract class SizedShaftBuilderBits implements ShaftBuilderBits, HasSize {}

extension SizedShaftBuilderBitsX on SizedShaftBuilderBits {
  SizedShaftBuilderBits withSize(Size size) =>
      ComposedSizedShaftBuilderBits.shaftBuilderBits(
        shaftBuilderBits: this,
        size: size,
      );

  SizedShaftBuilderBits withHeight(double height) => withSize(
        size.withHeight(height),
      );

  SizedShaftBuilderBits withWidth(double width) => withSize(
        size.withWidth(width),
      );
}

extension SizedNodeBuildBitsX on SizedShaftBuilderBits {
  Bx fillHeight(double height) => withHeight(height).fill();

  Bx fill() => leaf(null);

  Bx leaf(Widget? widget) => Bx.leaf(
        size: size,
        widget: widget,
      );

  Bx padding({
    required EdgeInsets padding,
    required SizedBuilder builder,
  }) {
    return Bx.pad(
      padding: padding,
      child: builder(
        withSize(
          padding.deflateSize(size),
        ),
      ),
      size: size,
    );
  }

  Bx centerHeight(Bx child) => Bx.padOrFill(
        padding: Paddings.centerY(
          outer: height,
          inner: child.height,
        ),
        child: child,
        size: Size(
          child.width,
          height,
        ),
      );

  Bx left(Bx child) {
    return Bx.padOrFill(
      padding: EdgeInsets.only(right: width - child.width),
      child: child,
      size: size,
    );
  }

  Bx top(Bx child) {
    return Bx.padOrFill(
      padding: Paddings.top(
        outer: height,
        inner: child.height,
      ),
      child: child,
      size: size,
    );
  }

  Bx topLeft(Bx child) {
    return Bx.padOrFill(
      padding: Paddings.topLeft(
        outer: size,
        inner: child.size,
      ),
      child: child,
      size: size,
    );
  }

  Bx fillLeft({
    required SizedBuilder left,
    required Bx right,
  }) {
    return Bx.row(
      columns: [
        left(
          withWidth(width - right.width),
        ),
        right,
      ],
      size: size,
    );
  }

  Bx fillRight({
    required Bx left,
    required SizedBuilder right,
  }) {
    return Bx.row(
      columns: [
        left,
        right(
          withWidth(width - left.width),
        ),
      ],
      size: size,
    );
  }

  Bx fillBottom({
    required Bx top,
    required SizedBuilder bottom,
  }) {
    return Bx.col(
      rows: [
        top,
        bottom(withHeight(height - top.height)),
      ],
      size: size,
    );
  }

  Bx fillTop({
    required SizedBuilder top,
    required Bx bottom,
  }) {
    return Bx.col(
      rows: [
        top(withHeight(height - bottom.height)),
        bottom,
      ],
      size: size,
    );
  }
}
