import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'icons.dart';

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
  final ui = appBits.ui;

  final opReg = ui.opReg;

  return flcDsp((disposers) {
    final handles = [
      (
        widget: MdiIcons.addColumn,
        state: opReg.register(
          action: () {
            return () {
              appBits.columnCount.update((v) => v + 1);
            };
          },
          disposers: disposers,
        ),
      ),
      (
        widget: MdiIcons.removeColumn,
        state: opReg.register(
          action: () {
            if (appBits.columnCount() <= 1) {
              return null;
            }
            return () {
              appBits.columnCount.update((v) => v - 1);
            };
          },
          disposers: disposers,
        ),
      ),
      (
        widget: MdiIcons.help,
        state: opReg.register(
          action: () {
            return () {
              print("help!");
            };
          },
          disposers: disposers,
        ),
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          flcFrr(() {
            return sizedRow(
              children: handles.map((handle) {
                final keys = handle.state();

                return sizedOpIcon(
                  icon: handle.widget,
                  keys: keys,
                  ui: ui,
                );
              }).toList(),
            ).widget;
          }),
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
  });
}
