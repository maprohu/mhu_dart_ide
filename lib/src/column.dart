import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/src/column/main_menu.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';

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

Widget buildColumn({
  required SizedNodeBuilderBits buildBits,
  required NodeBuilder header,
  required NodeBuilder body,
}) {
  final themeCalc = buildBits.themeCalc;
  final dividerThickness = themeCalc.columnHeaderDividerThickness;

  return Column(
    children: buildExpand(availableSpace: buildBits.height, items: [


    ]),

  );
  buildFlex(
    availableSpace: buildBits.height,
    fixedSize: themeCalc.columnHeaderHeight,
    dividerThickness: dividerThickness,
    items: [],
  );
}

SizedWidget buildColumnHeader({
  required double columnWidth,
  required NodeBuilder content,
  required ThemeCalc themeCalc,
}) {
  return Padding(padding: themeCalc.columnHeaderPadding,

  );
}
