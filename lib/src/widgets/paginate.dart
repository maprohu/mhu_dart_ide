import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/ui.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../app.dart';

part 'paginate.freezed.dart';

class HwPaginatorController {
  final firstIndex = fw(0);
}

Widget hwPaginator({
  double separator = 1,
  required double itemHeight,
  required int itemCount,
  required Iterable<Widget> Function(int from, int count) itemBuilder,
  required UiBuilder ui,
  required HwPaginatorController controller,
  HWidget Function(HWidget controls)? header,
}) {
  HWidget defaultHeader(HWidget controls) {
    return hwColumn(
      children: [
        controls.withPadding(),
        hwDivider(separator + 1),
      ],
    );
  }

  header ??= defaultHeader;

  return LayoutBuilder(
    builder: (context, constraints) {
      final height = constraints.maxHeight;

      final fitCount = itemFitCount(
        available: height,
        itemSize: itemHeight,
        separator: separator,
      );

      return flcFrr(() {
        if (itemCount <= fitCount) {
          // single page
          return sepColumn(
            itemBuilder(0, itemCount),
            thickness: separator,
          );
        } else {
          // paginate
          throw "todo";
        }
      });
    },
  );
}

int itemFitCount({
  required double available,
  required double itemSize,
  required double separator,
}) {
  final remaining = available - itemSize;
  if (remaining < 0) {
    return 0;
  }

  return 1 + (remaining ~/ (itemSize + separator));
}

@freezedStruct
class PaginatorBits with _$PaginatorBits {
  PaginatorBits._();

  factory PaginatorBits({
    required double itemHeight,
    required int itemCount,
    required Iterable<Widget> Function(int from, int count) itemBuilder,
  }) = _PaginatorBits;
}

typedef PaginatorRegistrar = PaginatorBits Function(DspReg disposers);

@freezedStruct
class PaginatorBuilder
    with _$PaginatorBuilder, ColumnWidgetBuilder, HasColumnBits, HasAppBits {
  PaginatorBuilder._();

  factory PaginatorBuilder({
    required ColumnWidgetParent parent,
    required WidgetLinker<PaginatorBits> linker,
  }) = _PaginatorBuilder;

  late final controller = HwPaginatorController();

  @override
  late final widget = linkWidget(
    linker: linker,
    builder: (bits) {
      return hwPaginator(
        itemHeight: bits.itemHeight,
        itemCount: bits.itemCount,
        itemBuilder: bits.itemBuilder,
        ui: ui,
        controller: controller,
      );
    },
  );
}
