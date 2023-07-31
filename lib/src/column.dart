import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/src/column/main_menu.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';

import '../proto.dart';
import 'flex.dart';
import 'screen.dart';

FlexNode<Widget> mdiColumnFlexNode({
  required NodeBuildBits buildBits,
  required MdiColumnMsg column,
}) {
  return FlexNode(
    grow: false,
    builder: (width) {
      return buildBits.sizedWidth(
        width: width,
        builder: (buildBits) {
          return switch (column.type) {
            MdiColumnMsg_Type$mainMenu(:final value) => mdiMainMenuColumn(
                buildBits: buildBits,
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

required NodeBuildBits buildBits,
required NodeBuilder header,
required NodeBuilder body,
}) {
  final dividerThickness = buildBits.themeCalc.columnHeaderDividerThickness;
  
  buildFlex(availableSpace: buildBits.height, fixedSize: fixedSize, dividerThickness: dividerThickness, items: items)

}

SizedWidget buildColumnHeader