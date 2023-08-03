import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/flex.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/default_shaft.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/widgets/paginate.dart';
import 'package:mhu_dart_ide/src/widgets/shortcut.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'app.dart';
import 'shaft.dart';
import 'op.dart';
import 'state.dart';
import 'widgets/boxed.dart';

part 'screen.freezed.dart';

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

final _defaultMainMenuShaft = MdiShaftMsg()
  ..ensureMainMenu()
  ..freeze();

const _defaultColumnCount = 15;

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

    final minColumnWidth = state.minShaftWidthOpt ??
        (screenWidth -
                ((_defaultColumnCount - 1) * shaftsVerticalDividerThickness)) /
            _defaultColumnCount;

    final shaftFitCount = itemFitCount(
      available: screenWidth,
      itemSize: minColumnWidth,
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
          Bx.verticalDivider(
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

typedef NodeBuilder = Bx Function(SizedShaftBuilderBits sizedBits);

@freezedStruct
class ShaftBuilderBits
    with
        _$ShaftBuilderBits,
        HasShaftDoubleChain,
        HasShaftCalc,
        HasShaftCalcChain,
        HasShaftMsg {
  ShaftBuilderBits._();

  factory ShaftBuilderBits({
    required MdiAppBits appBits,
    required OpBuilder opBuilder,
    required ShaftDoubleChain doubleChain,
  }) = _ShaftBuilderBits;

  late final configBits = appBits.configBits;

  late final themeCalc = configBits.themeCalc();
  late final stateCalc = configBits.stateCalc();

  SizedShaftBuilderBits sized(Size size) => SizedShaftBuilderBits(
        shaftBits: this,
        size: size,
      );

  SizedShaftBuilderBits sizedFrom({
    required double width,
    required double height,
  }) =>
      sized(Size(width, height));

  Bx sizedBxFrom({
    required double width,
    required double height,
    required Bx Function(SizedShaftBuilderBits sizedBits) builder,
  }) =>
      sizedBx(
        size: Size(width, height),
        builder: builder,
      );

  Bx sizedBx({
    required Size size,
    required Bx Function(SizedShaftBuilderBits sizedBits) builder,
  }) {
    return builder(sized(size));
  }
}

mixin HasShaftBuilderBits {
  ShaftBuilderBits get shaftBits;

  late final appBits = shaftBits.appBits;

  late final opBuilder = shaftBits.opBuilder;
  late final configBits = shaftBits.configBits;
  late final themeCalc = shaftBits.themeCalc;
  late final stateCalc = shaftBits.stateCalc;

  late final shaftMsg = shaftBits.shaftMsg;
}

@freezedStruct
class SizedShaftBuilderBits
    with _$SizedShaftBuilderBits, HasShaftBuilderBits, HasSize, HasThemeCalc {
  SizedShaftBuilderBits._();

  factory SizedShaftBuilderBits({
    required ShaftBuilderBits shaftBits,
    required Size size,
  }) = _SizedShaftBuilderBits;

  SizedShaftBuilderBits withSize(Size size) => copyWith(size: size);

  SizedShaftBuilderBits withHeight(double height) => copyWith(
        size: size.withHeight(height),
      );

  SizedShaftBuilderBits withWidth(double width) => copyWith(
        size: size.withWidth(width),
      );
}

mixin HasSizedBits {
  SizedShaftBuilderBits get sizedBits;

  late final size = sizedBits.size;
}

typedef ShortcutCallback = VoidCallback;

extension NodeBuildBitxX on ShaftBuilderBits {
  Bx shortcut(VoidCallback callback) {
    final handle = opBuilder.register(callback);

    return Bx.leaf(
      size: themeCalc.shortcutSize,
      widget: flcFrr(() {
        ShortcutData? data;
        final pressedCount = handle.watchState();
        if (pressedCount != null) {
          data = ShortcutData(
            shortcut: handle.shortcut(),
            pressedCount: pressedCount,
          );
        }
        return shortcutBx(
          data: data,
          themeCalc: themeCalc,
        ).layout();
      }),
    );
  }
}

extension SizedNodeBuildBitsX on SizedShaftBuilderBits {
  Bx fillHeight(double height) => withHeight(height).fill();

  Bx fill() => leaf(null);

  Bx leaf(Widget? widget) => Bx.leaf(
        size: size,
        widget: widget,
      );

  Bx padding({
    required EdgeInsets padding,
    required NodeBuilder builder,
  }) {
    return Bx.pad(
      padding: padding,
      child: builder(
        withSize(
          padding.deflateSize(size),
        ),
      ),
      size: size,
    );
  }

  Bx centerHeight(Bx child) => Bx.padOrFill(
        padding: Paddings.centerY(outer: height, inner: child.height),
        child: child,
        size: Size(
          child.width,
          height,
        ),
      );

  Bx left(Bx child) {
    return Bx.padOrFill(
      padding: EdgeInsets.only(right: width - child.width),
      child: child,
      size: size,
    );
  }

  Bx top(Bx child) {
    return Bx.padOrFill(
      padding: Paddings.top(
        outer: height,
        inner: child.height,
      ),
      child: child,
      size: size,
    );
  }

  Bx topLeft(Bx child) {
    return Bx.padOrFill(
      padding: Paddings.topLeft(
        outer: size,
        inner: child.size,
      ),
      child: child,
      size: size,
    );
  }
}

class ShaftDoubleChain
    with
        HasShaftCalc,
        HasShaftCalcChain,
        HasShaftMsg,
        HasParent<ShaftDoubleChain>,
        HasNext<ShaftDoubleChain> {
  @override
  final ShaftDoubleChain? parent;

  @override
  final ShaftCalc shaftCalc;

  @override
  late final next = ShaftDoubleChain(
    parent: this,
    shaftCalc: shaftCalc.shaftCalcChain.parent!.calc,
  );

  bool get hasLeft => shaftCalc.shaftCalcChain.parent != null;

  ShaftDoubleChain? get left => hasLeft ? next : null;

  ShaftDoubleChain? get right => parent;

  Iterable<ShaftDoubleChain> get iterableLeft sync* {
    yield this;
    final left = this.left;
    if (left != null) {
      // wonder if there is tail recursion optimization?
      yield* left.iterableLeft;
    }
  }

  late int parentWidthToEnd = parent?.widthToEnd ?? 0;

  late int widthToEnd = parentWidthToEnd + shaftWidth;

  ShaftDoubleChain({
    this.parent,
    required this.shaftCalc,
  });
}

mixin HasShaftDoubleChain {
  ShaftDoubleChain get doubleChain;

  late final shaftCalc = doubleChain.shaftCalc;
}
