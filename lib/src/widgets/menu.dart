import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/op_keys.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';

import '../op.dart';

part 'menu.freezed.dart';





@freezedStruct
class MenuBuilder with _$MenuBuilder, ColumnWidgetBuilder {
  MenuBuilder._();

  factory MenuBuilder({
    required ColumnWidgetParent parent,
    String? label,
    required List<MenuItemBits> Function(
      ColumnWidgetBits widgetBits,
    ) watchItems,
  }) = _MenuBuilder;

  @override
  late final widget = Text("hello");
}

@freezedStruct
class MenuItemBits with _$MenuItemBits {
  MenuItemBits._();

  factory MenuItemBits({
    required String label,
    required Watch<VoidCallback?> action,
    @Default(constantFalse) Watch<bool> isSelected,
  }) = _MenuItemBits;

  factory MenuItemBits.opener({
    required String label,
    required ColumnBits columnBits,
    required ColumnWidgetBits Function(ColumnBits columnBits) builder,
  }) {
    final appBits = columnBits.appBits;

    final selfFw = fw<ColumnWidgetBits?>(null);

    late final widgetBits = builder(columnBits.push()).also(selfFw.set);

    return MenuItemBits(
      label: label,
      action: () {
        return () {
          appBits.columnBits.value = widgetBits;
        };
      },
      isSelected: () {
        final current = selfFw();
        if (current == null) {
          return false;
        }
        return appBits.openColumnsSet().contains(current);
      },
    );
  }
}

extension ColumnWidgetMenuItemX on ColumnWidgetBits {
  MenuItemBits opener({
    required String label,
    required ColumnWidgetBits Function(ColumnWidgetParent parent) builder,
  }) {
    return MenuItemBits.opener(
      label: label,
      columnBits: columnBits,
      builder: (columnBits) {
        return builder(
          ColumnWidgetParent(
            columnBits: columnBits,
            parent: this,
          ),
        );
      },
    );
  }
}
