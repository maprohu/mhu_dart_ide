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
import 'column.dart';
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

final _defaultMainMenuColumn = MdiColumnMsg()
  ..ensureMainMenu()
  ..freeze();

const _defaultColumnCount = 5;

Bx mdiBuildScreen({
  required MdiAppBits appBits,
}) {
  final screenSize = appBits.screenSize();
  final screenWidth = screenSize.width;

  final opBuilder = OpBuilder();

  final nodeBits = NodeBuilderBits(
    appBits: appBits,
    opBuilder: opBuilder,
    after: null,
  );

  final ThemeCalc(
    :mainColumnsDividerThickness,
  ) = nodeBits.themeCalc;

  final StateCalc(
    :state,
  ) = nodeBits.stateCalc;

  final minColumnWidth = state.minColumnWidthOpt ??
      (screenWidth -
              ((_defaultColumnCount - 1) * mainColumnsDividerThickness)) /
          _defaultColumnCount;

  final columnCount = itemFitCount(
    available: screenWidth,
    itemSize: minColumnWidth,
    dividerThickness: mainColumnsDividerThickness,
  );

  final columns = state.columnOpt.columnsIterable.take(columnCount);

  final columnsAfter = columns.fold<ColumnsAfter?>(null, (after, column) {
    return ColumnsAfter(
      parent: after,
      column: column,
      flexNode: mdiColumnFlexNode(
        nodeBits: nodeBits.copyWith(
          after: after,
        ),
        height: screenSize.height,
        column: column,
      ),
    );
  });

  final columnWidgets = buildFlex(
    availableSpace: screenWidth,
    fixedSize: minColumnWidth,
    items: columnsAfter.childToParentIterable.map((e) => e.flexNode).toList(),
    dividerThickness: mainColumnsDividerThickness,
  ).toList();

  opBuilder.build();

  return Bx.rowWithDividers(
    columns: columnWidgets,
    thickness: mainColumnsDividerThickness,
    height: screenSize.height,
  );
}

typedef NodeBuilder = Bx Function(SizedNodeBuilderBits buildBits);

@freezedStruct
class NodeBuilderBits with _$NodeBuilderBits {
  NodeBuilderBits._();

  factory NodeBuilderBits({
    required MdiAppBits appBits,
    required OpBuilder opBuilder,
    required ColumnsAfter? after,
  }) = _NodeBuilderBits;

  late final configBits = appBits.configBits;

  late final themeCalc = configBits.themeCalc();
  late final stateCalc = configBits.stateCalc();

  SizedNodeBuilderBits sized(Size size) => SizedNodeBuilderBits(
        nodeBits: this,
        size: size,
      );

  Bx sizedBox({
    required Size size,
    required Bx Function(SizedNodeBuilderBits sizedBits) builder,
  }) {
    return builder(sized(size));
  }
}

mixin HasColumnBuildBits {
  NodeBuilderBits get nodeBits;

  late final opBuilder = nodeBits.opBuilder;
  late final configBits = nodeBits.configBits;
  late final themeCalc = nodeBits.themeCalc;
  late final stateCalc = nodeBits.stateCalc;
}

@freezedStruct
class SizedNodeBuilderBits with _$SizedNodeBuilderBits, HasColumnBuildBits {
  SizedNodeBuilderBits._();

  factory SizedNodeBuilderBits({
    required NodeBuilderBits nodeBits,
    required Size size,
  }) = _SizedNodeBuilderBits;

  late final height = size.height;
  late final width = size.width;

  SizedNodeBuilderBits withSize(Size size) => copyWith(size: size);
}

extension NodeBuildBitsX on SizedNodeBuilderBits {


  Bx shortcut(VoidCallback action) {
    return shortcutFr(fw(action));
  }

  Bx shortcutFr(Fr<VoidCallback?> callback) {
    final handle = opBuilder.register(callback.read);

    return Bx.leaf(
      size: themeCalc.shortcutSize,
      widget: flcFrr(() {
        ShortcutData? data;
        final cb = callback();
        if (cb != null) {
          final pressedCount = handle.watchState();
          if (pressedCount != null) {
            data = ShortcutData(
              shortcut: handle.shortcut(),
              pressedCount: pressedCount,
            );
          }
        }
        return shortcutBx(
          data: data,
          themeCalc: themeCalc,
        ).layout();
      }),
    );
  }
}

extension _MdiStateMsgX on MdiColumnMsg? {
  Iterable<MdiColumnMsg> get columnsIterable sync* {
    var c = this;
    while (c != null) {
      yield c;
      c = c.parentOpt;
    }
    yield _defaultMainMenuColumn;
  }
}

@freezedStruct
class ColumnsAfter with _$ColumnsAfter implements HasParent<ColumnsAfter> {
  ColumnsAfter._();

  factory ColumnsAfter({
    required ColumnsAfter? parent,
    required MdiColumnMsg column,
    required FlexNode<Bx> flexNode,
  }) = _ColumnsAfter;
}
