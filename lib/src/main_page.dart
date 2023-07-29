import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/op_icon.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'op.dart';

const hline = Divider(
  height: 1,
  thickness: 1,
  indent: 0,
  endIndent: 0,
);

const vline = VerticalDivider(
  width: 1,
  thickness: 1,
  indent: 0,
  endIndent: 0,
);

Widget mdiMainPage({
  required MdiAppBits appBits,
}) {
  final opReg = appBits.opScreen.root;

  final ui = appBits.ui;


  return Scaffold(
    body: Column(
      children: [
        Row(
          children: [
            opReg.icon(ops.addColumn, () {
              return () {
                appBits.columnCount.update((v) => v + 1);
              };
            }),
            opReg.icon(ops.removeColumn, () {
              if (appBits.columnCount() <= 1) {
                return null;
              }
              return () {
                appBits.columnCount.update((v) => v - 1);
              };
            }),
            opReg.icon(ops.help, () {
              return () {
                print("help!");
              };
            }),
          ],
        ),
        hline,
        Expanded(
          child: flcFrr(() {
            return MdiColumns(
              columnCount: appBits.columnCount(),
              top: appBits.columnBits(),
            );
          }),
        ),
      ],
    ),
  );
}
