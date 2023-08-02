import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/flex.dart';
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
      shaftsDividerThickness: mainColumnsDividerThickness,
    ) = appBits.themeCalc();

    final StateCalc(
      :state,
    ) = appBits.stateCalc();

    final minColumnWidth = state.minShaftWidthOpt ??
        (screenWidth -
                ((_defaultColumnCount - 1) * mainColumnsDividerThickness)) /
            _defaultColumnCount;

    final columnCount = itemFitCount(
      available: screenWidth,
      itemSize: minColumnWidth,
      dividerThickness: mainColumnsDividerThickness,
    );

    final columns = (state.topShaftOpt ?? _defaultMainMenuShaft)
        .columnsIterable
        .take(columnCount);

    final columnsAfter = columns.fold<ColumnsAfter?>(null, (after, column) {
      final nodeBits = NodeBuilderBits(
        appBits: appBits,
        opBuilder: opBuilder,
        after: after,
        shaftMsg: column,
      );
      return ColumnsAfter(
        parent: after,
        column: column,
        flexNode: mdiColumnFlexNode(
          nodeBits: nodeBits,
          height: screenSize.height,
          column: column,
        ),
      );
    });

    final columnWidgets = buildFlex(
      availableSpace: screenWidth,
      fixedSize: minColumnWidth,
      items: columnsAfter.childToParentIterable
          .map((e) => e.flexNode)
          .toList()
          .reversed
          .toList(),
      dividerThickness: mainColumnsDividerThickness,
    ).toList();

    return Bx.row(
      columns: columnWidgets.reversed
          .separatedBy(
            Bx.verticalDivider(
              thickness: mainColumnsDividerThickness,
              height: screenSize.height,
            ),
          )
          .toList(),
      size: screenSize,
    );
  });
}

typedef NodeBuilder = Bx Function(SizedNodeBuilderBits sizedBits);

@freezedStruct
class NodeBuilderBits with _$NodeBuilderBits {
  NodeBuilderBits._();

  factory NodeBuilderBits({
    required MdiAppBits appBits,
    required OpBuilder opBuilder,
    required ColumnsAfter? after,
    required MdiShaftMsg shaftMsg,
  }) = _NodeBuilderBits;

  late final configBits = appBits.configBits;

  late final themeCalc = configBits.themeCalc();
  late final stateCalc = configBits.stateCalc();

  SizedNodeBuilderBits sized(Size size) => SizedNodeBuilderBits(
        nodeBits: this,
        size: size,
      );

  SizedNodeBuilderBits sizedFrom({
    required double width,
    required double height,
  }) =>
      sized(Size(width, height));

  Bx sizedBxFrom({
    required double width,
    required double height,
    required Bx Function(SizedNodeBuilderBits sizedBits) builder,
  }) =>
      sizedBx(
        size: Size(width, height),
        builder: builder,
      );

  Bx sizedBx({
    required Size size,
    required Bx Function(SizedNodeBuilderBits sizedBits) builder,
  }) {
    return builder(sized(size));
  }
}

mixin HasColumnBuildBits {
  NodeBuilderBits get nodeBits;

  late final appBits = nodeBits.appBits;

  late final opBuilder = nodeBits.opBuilder;
  late final configBits = nodeBits.configBits;
  late final themeCalc = nodeBits.themeCalc;
  late final stateCalc = nodeBits.stateCalc;

  late final shaftMsg = nodeBits.shaftMsg;
}

@freezedStruct
class SizedNodeBuilderBits
    with _$SizedNodeBuilderBits, HasColumnBuildBits, HasSize {
  SizedNodeBuilderBits._();

  factory SizedNodeBuilderBits({
    required NodeBuilderBits nodeBits,
    required Size size,
  }) = _SizedNodeBuilderBits;

  SizedNodeBuilderBits withSize(Size size) => copyWith(size: size);

  SizedNodeBuilderBits withHeight(double height) => copyWith(
        size: size.withHeight(height),
      );

  SizedNodeBuilderBits withWidth(double width) => copyWith(
        size: size.withWidth(width),
      );
}

mixin HasSizedBits {
  SizedNodeBuilderBits get sizedBits;

  late final size = sizedBits.size;
}

typedef ShortcutCallback = VoidCallback;

extension NodeBuildBitxX on NodeBuilderBits {
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

extension SizedNodeBuildBitsX on SizedNodeBuilderBits {
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

extension _MdiShaftMsgX on MdiShaftMsg? {
  Iterable<MdiShaftMsg> get columnsIterable sync* {
    var c = this;
    while (c != null) {
      yield c;
      c = c.parentOpt;
    }
  }
}

@freezedStruct
class ColumnsAfter with _$ColumnsAfter implements HasParent<ColumnsAfter> {
  final inherited = TypedCache();

  ColumnsAfter._();

  factory ColumnsAfter({
    required ColumnsAfter? parent,
    required MdiShaftMsg column,
    required FlexNode<Bx> flexNode,
  }) = _ColumnsAfter;
}
