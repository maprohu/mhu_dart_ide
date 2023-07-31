import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/src/column/main_menu.dart';
import 'package:mhu_dart_ide/src/theme.dart';

import '../proto.dart';
import 'flex.dart';
import 'screen.dart';
import 'widgets/boxed.dart';

FlexNode<Bx> mdiColumnFlexNode({
  required NodeBuilderBits nodeBits,
  required double height,
  required MdiColumnMsg column,
}) {
  return FlexNode(
    grow: false,
    builder: (width) {
      return nodeBits.sizedBox(
        size: Size(width, height),
        builder: (sizedBits) {
          return switch (column.type) {
            MdiColumnMsg_Type$mainMenu(:final value) => mdiMainMenuColumn(
                buildBits: sizedBits,
                value: value,
              ),
            _ => throw column,
          };
        },
      );
    },
  );
}

Bx buildColumn({
  required SizedNodeBuilderBits sizedBits,
  required NodeBuilder header,
  required NodeBuilder body,
}) {
  final SizedNodeBuilderBits(
    :width,
    :height,
    :themeCalc,
    :nodeBits,
  ) = sizedBits;

  final dividerThickness = themeCalc.columnHeaderDividerThickness;

  final rows = buildExpand(availableSpace: height, items: [
    ExpandNode.height(
      Bx.col([
        columnHeaderBx(
          nodeBits: nodeBits,
          columnWidth: width,
          content: header,
          themeCalc: themeCalc,
        ),
        Bx.horizontalDivider(
          thickness: dividerThickness,
          width: width,
        )
      ]),
    ),
  ]);

  return Bx.col(rows.toList());
}

Bx columnHeaderBx({
  required NodeBuilderBits nodeBits,
  required double columnWidth,
  required NodeBuilder content,
  required ThemeCalc themeCalc,
}) {
  final padding = themeCalc.columnHeaderPadding;
  final contentSize = Size(
    columnWidth - padding.horizontal,
    themeCalc.columnHeaderContentHeight,
  );
  return Bx.pad(
    padding: themeCalc.columnHeaderPadding,
    child: content(nodeBits.sized(contentSize)),
  );
}
