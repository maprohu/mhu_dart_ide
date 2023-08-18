import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/long_running.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../proto.dart';
import '../app.dart';
import '../builder/double.dart';
import '../builder/shaft.dart';
import 'shaft.dart';
import '../state.dart';
import '../theme.dart';
import 'boxed.dart';
import 'paginate.dart';
import '../screen/calc.dart';
import 'divider.dart';

final defaultMainMenuShaft = MdiShaftMsg()
  ..ensureDefaultMainMenu()
  ..freeze();

extension DefaultMainMenuShaftMsgX on ShaftMsg {
  void ensureDefaultMainMenu() {
    ensureShaftIdentifier().ensureMainMenu();
  }
}

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

    final topCalcChain = ComposedShaftCalcChain.appBits(
      appBits: appBits,
      shaftMsg: state.effectiveTopShaft,
      shaftIndexFromRight: 0,
      stateMsg: state,
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
        .mapIndexed((index, sw) {
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

          final extraContent = index == 0
              ? longRunningTasksShaftContent(
                  appBits: sizedBits,
                )
              : null;

          return defaultShaftBx(
            sizedBits: sizedBits,
            extraContent: extraContent,
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

void mdiStartScreenStream({
  required AppBits appBits,
  required DspReg disposers,
  required StreamConsumer<Bx> screenStream,
}) {
  disposers
      .fr(() {
        return mdiBuildScreen(appBits: appBits);
      })
      .changes()
      .let(screenStream.addStream);
}

extension ScreenMdiStateMsgX on MdiStateMsg {
  MdiShaftMsg get effectiveTopShaft => topShaftOpt ?? defaultMainMenuShaft;

  MdiShaftMsg ensureEffectiveTopShaft() =>
      topShaftOpt ?? (ensureTopShaft()..ensureDefaultMainMenu());
}

extension ScreenMdiShaftMsgX on MdiShaftMsg {
  Iterable<MdiShaftMsg> get toShaftIterable =>
      finiteIterable((item) => item.parentOpt);

  MdiShaftMsg getShaftByIndex(int index) {
    return toShaftIterable.skip(index).first;
  }

  MdiShaftMsg getShaftByIndexFromLeft(ShaftIndexFromLeft shaftIndexFromLeft) {
    final iterable = toShaftIterable;
    final length = iterable.length;
    return iterable.skip(length - shaftIndexFromLeft - 1).first;
  }
}
