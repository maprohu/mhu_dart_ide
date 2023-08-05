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
  required AppBits appBits,
}) {
  final screenSize = appBits.screenSizeFr();
  final screenWidth = screenSize.width;

  final opBuilder = appBits.opBuilder;

  return opBuilder.build(() {
    final ThemeCalc(
      shaftsDividerThickness: shaftsVerticalDividerThickness,
    ) = appBits.themeCalcFr();

    final StateCalc(
      :state,
    ) = appBits.stateCalcFr();

    final minShaftWidth = state.minShaftWidthOpt ?? _defaultMinShaftWidth;

    final shaftFitCount = itemFitCount(
      available: screenWidth,
      itemSize: minShaftWidth,
      dividerThickness: shaftsVerticalDividerThickness,
    );

    final topShaftMsg = (state.topShaftOpt ?? _defaultMainMenuShaft);

    final topCalcChain = ComposedShaftCalcChain.appBits(
      appBits: appBits,
      shaftMsg: topShaftMsg,
    );

    final doubleChain = ComposedShaftDoubleChain(
      shaftCalcChain: topCalcChain,
    );

    final visibleShaftsWithWidths = doubleChain.iterableLeft
        .map((s) {
          final widthLeft = shaftFitCount - s.widthOnRight;
          return (
            shaft: s,
            width: min(widthLeft, s.shaftCalcChain.shaftWidth),
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
          final shaftBits = ComposedShaftBuilderBits.shaftCalc(
            shaftCalc: shaft.shaftCalcChain.calc,
            shaftDoubleChain: shaft,
          );

          final sizedBits = shaftBits.sized(
            screenSize.withWidth(
              width * singleShaftWidth +
                  ((width - 1) * shaftsVerticalDividerThickness),
            ),
          );

          return defaultShaftBx(
            sizedBits: sizedBits,
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
  required AppBits appBits,
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
