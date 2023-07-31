import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

part 'boxed.freezed.dart';

@freezedStruct
sealed class Bx with _$Bx, HasSize {
  Bx._();

  @Assert("columns.map((e) => e.height).allRoughlyEqual()")
  factory Bx.row(List<Bx> columns) = BxRow;

  @Assert("rows.map((e) => e.width).allRoughlyEqual()")
  factory Bx.col(List<Bx> rows) = BxCol;

  factory Bx.pad({
    required EdgeInsets padding,
    required Bx child,
  }) = BxPad;

  @Assert("widget is! SizedBox")
  factory Bx.leaf({
    required Size size,
    required Widget? widget,
  }) = BxLeaf;

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

  @override
  late final Size size = switch (this) {
    BxLeaf(:final size) => size,
    BxPad(:final padding, :final child) => padding.inflateSize(child.size),
    BxRow(:final columns) => Size(
        columns.map((e) => e.width).sum,
        columns.first.height,
      ),
    BxCol(:final rows) => Size(
        rows.first.width,
        rows.map((e) => e.height).sum,
      ),
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

  static Bx rowWithDividers({
    required List<Bx> columns,
    required double thickness,
    required double height,
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
      columns.separatedBy(divider).toList(),
    );
  }

  static Bx columnWithDividers({
    required List<Bx> rows,
    required double thickness,
    required double width,
  }) {
    final divider = horizontalDivider(
      thickness: thickness,
      width: width,
    );
    return Bx.col(
      rows.separatedBy(divider).toList(),
    );
  }

  static Bx horizontalDivider({
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

  static Iterable<Bx> buildWithLargest(List<BxLargest> items) {
    final size = items.map((e) => e.size).max;
    return items.map((e) => e.builder(size));
  }

  static Bx colCentered(List<Bx> rows) {
    return Bx.col(
      buildWithLargest(
        rows
            .map(
              (bx) => BxLargest(
                size: bx.width,
                builder: (width) => centerAlongX(
                  bx: bx,
                  width: width,
                ),
              ),
            )
            .toList(),
      ).toList(),
    );
  }

  static Bx rowCentered(List<Bx> columns) {
    return Bx.col(
      buildWithLargest(
        columns
            .map(
              (bx) => BxLargest(
                size: bx.height,
                builder: (height) => centerAlongY(
                  bx: bx,
                  height: height,
                ),
              ),
            )
            .toList(),
      ).toList(),
    );
  }

  static Bx centerAlongX({
    required Bx bx,
    required double width,
  }) {
    final margin = (width - bx.width) / 2;
    return Bx.pad(
      padding: EdgeInsets.symmetric(
        horizontal: margin,
      ),
      child: bx,
    );
  }

  static Bx centerAlongY({
    required Bx bx,
    required double height,
  }) {
    final margin = (height - bx.height) / 2;
    return Bx.pad(
      padding: EdgeInsets.symmetric(
        vertical: margin,
      ),
      child: bx,
    );
  }
}

@freezedStruct
class BxLargest with _$BxLargest {
  BxLargest._();

  factory BxLargest({
    required double size,
    required Bx Function(double largest) builder,
  }) = _BxLargest;
}
