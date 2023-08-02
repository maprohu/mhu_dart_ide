import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen.dart';
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

  static Bx rowWithDividers({
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

  static Bx columnWithDividers({
    required List<Bx> rows,
    required double thickness,
    required double width,
    required Size size,
  }) {
    final divider = horizontalDivider(
      thickness: thickness,
      width: width,
    );
    return Bx.col(
      rows: rows.separatedBy(divider).toList(),
      size: size,
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

// static Bx colCentered(List<Bx> rows) {
//   return Bx.col(
//     buildWithLargest(
//       rows
//           .map(
//             (bx) => BxLargest(
//               size: bx.width,
//               builder: (width) => centerAlongX(
//                 bx: bx,
//                 width: width,
//               ),
//             ),
//           )
//           .toList(),
//     ).toList(),
//   );
// }

// static Bx rowCentered(List<Bx> columns) {
//   return Bx.col(
//     buildWithLargest(
//       columns
//           .map(
//             (bx) => BxLargest(
//               size: bx.height,
//               builder: (height) => centerAlongY(
//                 bx: bx,
//                 height: height,
//               ),
//             ),
//           )
//           .toList(),
//     ).toList(),
//   );
// }

// static Bx centerAlongX({
//   required Bx bx,
//   required double width,
// }) {
//   final margin = (width - bx.width) / 2;
//   return Bx.pad(
//     padding: EdgeInsets.symmetric(
//       horizontal: margin,
//     ),
//     child: bx,
//   );
// }

// static Bx centerAlongY({
//   required Bx bx,
//   required double height,
// }) {
//   final margin = (height - bx.height) / 2;
//   return Bx.pad(
//     padding: EdgeInsets.symmetric(
//       vertical: margin,
//     ),
//     child: bx,
//   );
// }
}

@freezedStruct
class BxLargest with _$BxLargest {
  BxLargest._();

  factory BxLargest({
    required double size,
    required Bx Function(double largest) builder,
  }) = _BxLargest;
}

extension BxSizedBuilderX on SizedNodeBuilderBits {
  Bx col(
    Iterable<Bx> Function(double width) builder,
  ) {
    return Bx.col(
      rows: builder(width).toList(),
      size: size,
    );
  }
}

class Paddings {
  static EdgeInsets topLeft({
    required Size outer,
    required Size inner,
  }) {
    return EdgeInsets.only(
      right: outer.width - inner.width,
      bottom: outer.height - inner.height,
    );
  }

  static EdgeInsets centerLeft({
    required Size outer,
    required Size inner,
  }) {
    final vertical = (outer.height - inner.height) / 2;
    return EdgeInsets.only(
      right: outer.width - inner.width,
      top: vertical,
      bottom: vertical,
    );
  }

  static EdgeInsets centerY({
    required double outer,
    required double inner,
  }) {
    final half = (outer - inner) / 2;
    return EdgeInsets.only(
      top: half,
      bottom: half,
    );
  }
}

// @freezedStruct
// class SizedBx with _$SizedBx {
//   SizedBx._();
//
//   @Assert("assertSizeRoughlyEqual(bx.size, size)")
//   factory SizedBx({
//     required Bx bx,
//     required Size size,
//   }) = _SizedBx;
// }
//
// extension SizedBxHasSizeX on HasSize {
//   SizedBx sizedBx(Bx bx) => SizedBx(
//         bx: bx,
//         size: size,
//       );
// }
//
// extension BxSizedBitsX on Bx {
//   SizedBx sizedWith(HasSize size) => size.sizedBx(this);
// }
