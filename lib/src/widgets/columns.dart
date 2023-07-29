import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/main_page.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

part 'columns.freezed.dart';

class MdiColumns extends StatelessWidget {
  final ColumnWidgetBits? top;
  final int columnCount;
  final Widget emptyColumn;

  const MdiColumns({
    super.key,
    required this.top,
    required this.columnCount,
    this.emptyColumn = nullWidget,
  });

  @override
  Widget build(BuildContext context) {
    final columns = top.childToParentIterable
        .map((e) => e.widget)
        .take(columnCount)
        .toList()
        .reversed
        .followedBy(infiniteSingleElementIterator(emptyColumn))
        .map<Widget>((e) => Expanded(child: e))
        .take(columnCount);

    return Row(
      children: [
        ...columns.separatedBy(vline),
      ],
    );
  }
}

@freezed
class ColumnBits with _$ColumnBits, HasAppBits, HasParent<ColumnBits> {
  const factory ColumnBits({
    required MdiAppBits appBits,
    required ColumnBits? parent,
    required OpReg opReg,
  }) = _ColumnBits;
}

mixin HasColumnBits {
  ColumnBits get columnBits;

  late final appBits = columnBits.appBits;
}

extension ColumnBitsX on ColumnBits {
  ColumnBits push() => copyWith(
        parent: this,
        opReg: opReg.push(),
      );

  ForkBits fork() => ForkBits(
        columnBits: this,
        opReg: opReg.fork(),
      );
}

@freezedStruct
class ForkBits with _$ForkBits, HasColumnBits, HasAppBits {
  ForkBits._();

  factory ForkBits({
    required ColumnBits columnBits,
    required OpReg opReg,
  }) = _ForkBits;
}

@freezedStruct
class ColumnWidgetParent with _$ColumnWidgetParent, HasColumnBits, HasAppBits {
  ColumnWidgetParent._();

  factory ColumnWidgetParent({
    required ColumnBits columnBits,
    ColumnWidgetBits? parent,
  }) = _ColumnWidgetParent;

  factory ColumnWidgetParent.fromWidget(ColumnWidgetBits parent) =>
      ColumnWidgetParent(
        columnBits: parent.columnBits,
        parent: parent,
      );
}

@freezedStruct
class ColumnWidgetBits
    with
        _$ColumnWidgetBits,
        HasColumnBits,
        HasAppBits,
        HasParent<ColumnWidgetBits> {
  ColumnWidgetBits._();

  factory ColumnWidgetBits({
    required ColumnWidgetBits? parent,
    required ColumnBits columnBits,
    required Widget widget,
  }) = _ColumnWidgetBits;
}

mixin ColumnWidgetBuilder {
  ColumnWidgetParent get parent;

  Widget get widget;

  late final widgetBits = ColumnWidgetBits(
    parent: parent.parent,
    columnBits: parent.columnBits,
    widget: widget,
  );

  late final widgetParent = ColumnWidgetParent.fromWidget(widgetBits);
}

Widget sepColumn(
  Iterable<Widget> children, {
  double thickness = 1.0,
}) {
  return sepFlex(
    children: children,
    thickness: thickness,
    direction: Axis.vertical,
  );
}

Widget sepRow(
  Iterable<Widget> children, {
  double thickness = 1,
}) {
  return sepFlex(
    children: children,
    thickness: thickness,
    direction: Axis.horizontal,
  );
}

Widget sepFlex({
  required Iterable<Widget> children,
  double thickness = 1,
  required Axis direction,
}) {
  final separator = switch (direction) {
    Axis.horizontal => VerticalDivider(
        width: thickness,
        thickness: thickness,
        indent: 0,
        endIndent: 0,
      ),
    Axis.vertical => Divider(
        height: thickness,
        thickness: thickness,
        indent: 0,
        endIndent: 0,
      ),
  };
  return Flex(
    direction: direction,
    children: children.separatedBy(separator).toList(),
  );
}