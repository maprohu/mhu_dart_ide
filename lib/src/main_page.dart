import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'icons.dart';
import 'op_registry.dart';

part 'main_page.freezed.dart';

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

@freezed
class DrawData with _$DrawData {
  const factory DrawData({
    required Size size,
    required OpStates opStates,
    required int pressedCount,
  }) = _DrawData;
}

Widget mdiMainPage({
  required MdiAppBits appBits,
  required Widget Function(DrawData data) watchScreen,
}) {
  final opScreen = appBits.opScreen;

  return LayoutBuilder(
    builder: (context, constraints) {
      final height = constraints.maxHeight;
      final width = constraints.maxWidth;

      final size = Size(width, height);

      return flcFrr(() {
        final opStates = opScreen.opStates();
        final pressedCount = opScreen.pressedCount();

        final drawData = DrawData(
          size: size,
          opStates: opStates,
          pressedCount: pressedCount,
        );

        return watchScreen(drawData);
      }).withKey(constraints);
    },
  );
}

Widget watchMdiMainScreen({
  required DrawData data,
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
            return Act.act(() {
              appBits.columnCount.update((v) => v + 1);
            });
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
            return Act.act(() {
              appBits.columnCount.update((v) => v - 1);
            });
          },
          disposers: disposers,
        ),
      ),
      (
        widget: MdiIcons.help,
        state: opReg.register(
          action: () {
            return Act.act(() {
              print("help!");
            });
          },
          disposers: disposers,
        ),
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          flcFrr(() {
            final pressedCount = appBits.opScreen.pressedCount();
            return sizedRow(
              children: handles.map((handle) {
                final keys = handle.state();

                return sizedOpIcon(
                  icon: handle.widget,
                  keys: keys,
                  ui: ui,
                  pressedCount: pressedCount,
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
