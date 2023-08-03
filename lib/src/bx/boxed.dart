import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';


part 'boxed.freezed.dart';

extension _Assert on Iterable<double> {
  bool _assertEqual() {
    assert(allRoughlyEqual(), toString());
    return true;
  }
}

@freezedStruct
sealed class Bx with _$Bx, HasSize {
  Bx._();

  @Assert("Bx.calculateRowSize(columns).assertEqual(size)")
  factory Bx.row({
    required List<Bx> columns,
    required Size size,
  }) = BxRow;

  @Assert("Bx.calculateColumnSize(rows).assertEqual(size)")
  factory Bx.col({
    required List<Bx> rows,
    required Size size,
  }) = BxCol;

  @Assert("Bx.calculatePadSize(padding, child).assertEqual(size)")
  factory Bx.pad({
    required Size size,
    required EdgeInsets padding,
    required Bx child,
  }) = BxPad;

  @Assert("widget is! SizedBox")
  factory Bx.leaf({
    required Size size,
    required Widget? widget,
  }) = BxLeaf;

  static const overflow = Placeholder();

  static Bx padOrFill({
    required EdgeInsets padding,
    required Bx child,
    required Size size,
  }) =>
      padding.isNonNegative
          ? Bx.pad(padding: padding, child: child, size: size)
          : Bx.leaf(size: size, widget: overflow);

  static Bx fill(Size size) => Bx.leaf(
        size: size,
        widget: null,
      );

  static Bx fillWith({
    double width = 0,
    double height = 0,
  }) =>
      Bx.fill(
        Size(width, height),
      );

  static Size calculatePadSize(
    EdgeInsets padding,
    Bx child,
  ) {
    assert(padding.isNonNegative, padding.toString());
    return padding.inflateSize(child.size);
  }

  static Size calculateColumnSize(
    Iterable<Bx> rows,
  ) {
    rows.map((e) => e.width)._assertEqual();
    return Size(
      rows.first.width,
      rows.map((e) => e.height).sum,
    );
  }

  static Size calculateRowSize(
    Iterable<Bx> columns,
  ) {
    columns.map((e) => e.height)._assertEqual();
    return Size(
      columns.map((e) => e.width).sum,
      columns.first.height,
    );
  }

  Size calculateSize() => switch (this) {
        BxLeaf(:final size) => size,
        BxPad(:final padding, :final child) => calculatePadSize(padding, child),
        BxRow(:final columns) => calculateRowSize(columns),
        BxCol(:final rows) => calculateColumnSize(rows),
      };

  Widget layout() => switch (this) {
        BxLeaf(:final size, :final widget) => SizedBox.fromSize(
            size: size,
            child: widget,
          ),
        BxPad(:final padding, :final child) => Padding(
            padding: padding,
            child: child.layout(),
          ),
        BxRow(:final columns) => Row(
            children: columns.map((e) => e.layout()).toList(),
          ),
        BxCol(:final rows) => Column(
            children: rows.map((e) => e.layout()).toList(),
          ),
      };


}



