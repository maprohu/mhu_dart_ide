import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

part 'boxed.freezed.dart';

@freezedStruct
sealed class Bx with _$Bx, HasSize {
  Bx._();

  @Assert("columns.map((e) => e.height).allRoughlyEqual()")
  factory Bx.row(List<Bx> columns) = BxRow;

  @Assert("columns.map((e) => e.width).allRoughlyEqual()")
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

  Bx rowWithDividers({
    required List<Bx> columns,
    required double thickness,
    double? height,
  }) {
    height ??= columns.first.height;

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

  Bx columnWithDividers({
    required List<Bx> rows,
    required double thickness,
    double? width,
  }) {
    width ??= rows.first.width;

    final divider = Bx.leaf(
      size: Size(width, thickness),
      widget: Divider(
        height: thickness,
        thickness: thickness,
        indent: 0,
        endIndent: 0,
      ),
    );
    return Bx.col(
      rows.separatedBy(divider).toList(),
    );
  }
}
