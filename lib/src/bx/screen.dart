import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../proto.dart';
import '../app.dart';
import '../builder/double.dart';
import '../builder/shaft.dart';
import '../builder/sized.dart';
import 'shaft.dart';
import '../state.dart';
import '../theme.dart';
import 'boxed.dart';
import 'paginate.dart';
import '../screen/calc.dart';
import 'divider.dart';


final _defaultMainMenuShaft = MdiShaftMsg()
  ..ensureMainMenu()
  ..freeze();

const _defaultMinShaftWidth = 200.0;

Bx mdiBuildScreen({
  required MdiAppBits appBits,
}) {
  final screenSize = appBits.screenSize();
  final screenWidth = screenSize.width;

  final opBuilder = appBits.opBuilder;

  return opBuilder.build(() {
    final ThemeCalc(
      shaftsDividerThickness: shaftsVerticalDividerThickness,
    ) = appBits.themeCalc();

    final StateCalc(
      :state,
    ) = appBits.stateCalc();

    final minShaftWidth = state.minShaftWidthOpt ?? _defaultMinShaftWidth;

    final shaftFitCount = itemFitCount(
      available: screenWidth,
      itemSize: minShaftWidth,
      dividerThickness: shaftsVerticalDividerThickness,
    );

    final topShaftMsg = (state.topShaftOpt ?? _defaultMainMenuShaft);

    final topCalcChain = ShaftCalcChain(
      appBits: appBits,
      shaftMsg: topShaftMsg,
    );

    final doubleChain = ShaftDoubleChain(
      parent: null,
      shaftCalc: topCalcChain.calc,
    );

    final visibleShaftsWithWidths = doubleChain.iterableLeft
        .map((s) {
          final widthLeft = shaftFitCount - s.parentWidthToEnd;
          return (
            shaft: s,
            width: min(widthLeft, s.shaftWidth),
          );
        })
        .takeWhile(
          (v) => v.width > 0,
        )
        .toList();

    final actualShaftUnitCount =
        visibleShaftsWithWidths.map((e) => e.width).sum;

    final singleShaftWidth = (screenWidth -
            ((actualShaftUnitCount - 1) * shaftsVerticalDividerThickness)) /
        actualShaftUnitCount;

    final visibleShafts = visibleShaftsWithWidths
        .map((sw) {
          final (:shaft, :width) = sw;
          final shaftBits = ShaftBuilderBits(
            appBits: appBits,
            opBuilder: opBuilder,
            doubleChain: shaft,
          );

          final sizedBits = SizedShaftBuilderBits(
            shaftBits: shaftBits,
            size: screenSize.withWidth(
              width * singleShaftWidth +
                  ((width - 1) * shaftsVerticalDividerThickness),
            ),
          );

          return defaultShaftBx(
            sizedBits: sizedBits,
            shaftCalc: shaft.shaftCalc,
          );
        })
        .toList()
        .reversed
        .separatedBy(
          verticalDividerBx(
            thickness: shaftsVerticalDividerThickness,
            height: screenSize.height,
          ),
        );

    return Bx.row(
      columns: visibleShafts.toList(),
      size: screenSize,
    );
  });
}

ValueListenable<Bx> mdiScreenListenable({
  required MdiAppBits appBits,
  required DspReg disposers,
}) {
  final notifier = ValueNotifier<Bx>(
    Bx.leaf(
      size: Size.zero,
      widget: null,
    ),
  );

  disposers
      .fr(() {
    return mdiBuildScreen(appBits: appBits);
  })
      .changes()
      .forEach((widget) {
    notifier.value = widget;
  });

  return notifier;
}
