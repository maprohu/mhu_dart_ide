import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'icons.dart';
import 'op.dart';
import 'widgets/columns.dart';
import 'widgets/sized.dart' as sized;

part 'ui.freezed.dart';

@freezedStruct
class UiBuilder with _$UiBuilder {
  UiBuilder._();

  factory UiBuilder({
    required OpReg opReg,
    required TextBuilder itemText,
    required TextBuilder headerText,
    required TextBuilder keysText,
    required TextBuilder keysPressedText,
  }) = _UiBuilder;

  late final columnHeaderSizer = this.sizedOpIcon(
    icon: MdiIcons.help,
    keys: null,
    pressedCount: 0,
  );
}

extension UiBuilderX on UiBuilder {
  UiBuilder withOpReg(OpReg opReg) => copyWith(opReg: opReg);

  HasSizedWidget sizedKeys({
    required Keys? keys,
    required int pressedCount,
  }) =>
      sized.sizedKeys(
        keys: keys,
        ui: this,
        pressedCount: pressedCount,
      );

  HasSizedWidget sizedOpIcon({
    required HasSizedWidget icon,
    required Keys? keys,
    required int pressedCount,
  }) =>
      sized.sizedOpIcon(
        icon: icon,
        keys: keys,
        ui: this,
        pressedCount: pressedCount,
      );

  static const headerSeparator = 2.0;

  Widget buildColumn({
    required ColumnParts Function(double height) column,
    required ColumnHeaderParts headerParts,
  }) {
    SizedWidget header({
      SizedWidget? left,
      Widget? header,
      SizedWidget? right,
    }) {
      final row = sizedRow(
        children: [
          if (left != null) left,
          header == null
              ? nullSizedWidget.expanded
              : header.withSize(width: 0, height: 0).expanded,
          if (right != null) right,
        ],
      )
          .sizedBox(
            height: columnHeaderSizer.height,
          )
          .withPadding();

      return sizedColumn(
        children: [
          row,
          columnDivider(headerSeparator),
        ],
      );
    }

    final headerHeight = header().height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final columnHeight = height - headerHeight;

        final columnParts = column(columnHeight);

        return Column(
          key: ValueKey(height),
          children: [
            header(
              left: headerParts.left,
              header: columnParts.header,
              right: headerParts.right,
            ).widget,
            Expanded(
              child: columnParts.body,
            ),
          ],
        );
      },
    );
  }
}
