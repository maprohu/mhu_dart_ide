import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/divider.dart';
import 'package:mhu_dart_ide/src/flex.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/widgets/paginate.dart';
import 'package:mhu_dart_ide/src/widgets/shortcut.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'app.dart';
import 'column.dart';
import 'op.dart';
import 'state.dart';

part 'screen.freezed.dart';

ValueListenable<Widget> mdiScreenListenable({
  required MdiAppBits appBits,
  required DspReg disposers,
}) {
  final notifier = ValueNotifier<Widget>(busyWidget);

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

Widget mdiBuildScreen({
  required MdiAppBits appBits,
}) {
  final screenSize = appBits.screenSize();
  final screenWidth = screenSize.width;

  final opBuilder = OpBuilder();

  final buildBits = NodeBuildBits(
    appBits: appBits,
    opBuilder: opBuilder,
    after: null,
    size: screenSize,
  );

  final ThemeCalc(
    :mainColumnsDividerThickness,
  ) = buildBits.themeCalc;

  final StateCalc(
    :state,
  ) = buildBits.stateCalc;

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
        buildBits: buildBits.copyWith(
          after: after,
        ),
        column: column,
      ),
    );
  });

  final columnWidgets = buildFlex(
    availableSpace: buildBits.size.width,
    fixedSize: minColumnWidth,
    items: columnsAfter.childToParentIterable.map((e) => e.flexNode).toList(),
    dividerThickness: mainColumnsDividerThickness,
  ).toList();

  opBuilder.build();

  return rowWithDividers(
    children: columnWidgets,
    dividerThickness: mainColumnsDividerThickness,
  );
}

@freezedStruct
class NodeBuildBits with _$NodeBuildBits {
  NodeBuildBits._();

  factory NodeBuildBits({
    required MdiAppBits appBits,
    required OpBuilder opBuilder,
    required ColumnsAfter? after,
    required Size size,
  }) = _NodeBuildBits;

  late final configBits = appBits.configBits;

  late final themeCalc = configBits.themeCalc();
  late final stateCalc = configBits.stateCalc();
}

extension NodeBuildBitsX on NodeBuildBits {
  Widget sizedHeight({
    required double height,
    required Widget Function(NodeBuildBits buildBits) builder,
  }) {
    return sizedBox(
      size: Size(
        size.width,
        height,
      ),
      builder: builder,
    );
  }

  Widget sizedWidth({
    required double width,
    required Widget Function(NodeBuildBits buildBits) builder,
  }) {
    return sizedBox(
      size: Size(
        width,
        size.height,
      ),
      builder: builder,
    );
  }

  Widget sizedBox({
    required Size size,
    required Widget Function(NodeBuildBits buildBits) builder,
  }) {
    return SizedBox.fromSize(
      size: size,
      child: builder(
        copyWith(
          size: size,
        ),
      ),
    );
  }

  Widget shortcut(VoidCallback action) {
    return shortcutFr(fw(action));
  }

  Widget shortcutFr(Fr<VoidCallback?> callback) {
    final handle = opBuilder.register(callback.read);

    return SizedBox.fromSize(
      size: themeCalc.shortcutSize,
      child: flcFrr(() {
        final cb = callback();
        if (cb == null) {
          return nullWidget;
        }
        final pressedCount = handle.watchState();
        if (pressedCount == null) {
          return nullWidget;
        }
        return shortcutWidget(
          shortcut: handle.shortcut(),
          pressedCount: pressedCount,
          themeCalc: themeCalc,
        );
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
    required FlexNode<Widget> flexNode,
  }) = _ColumnsAfter;
}
