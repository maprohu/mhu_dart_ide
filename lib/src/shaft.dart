import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/src/theme.dart';

import '../proto.dart';
import 'flex.dart';
import 'screen.dart';
import 'shaft/main_menu.dart';
import 'widgets/boxed.dart';

FlexNode<Bx> mdiColumnFlexNode({
  required NodeBuilderBits nodeBits,
  required double height,
  required MdiShaftMsg column,
}) {
  return FlexNode(
    grow: false,
    builder: (width) {
      return nodeBits.sizedBxFrom(
        width: width,
        height: height,
        builder: (sizedBits) {
          return switch (column.type) {
            MdiShaftMsg_Type$mainMenu(:final value) => mdiMainMenuShaftBx(
                sizedBits: sizedBits,
                value: value,
              ),
            _ => throw column,
          };
        },
      );
    },
  );
}

Bx shaftBx({
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

  final dividerThickness = themeCalc.shaftHeaderDividerThickness;

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
  final padding = themeCalc.shaftHeaderPadding;
  final contentSize = Size(
    columnWidth - padding.horizontal,
    themeCalc.shaftHeaderContentHeight,
  );
  return Bx.pad(
    padding: themeCalc.shaftHeaderPadding,
    child: content(nodeBits.sized(contentSize)),
  );
}
