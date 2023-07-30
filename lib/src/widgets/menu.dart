import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/ui.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/op_keys.dart';
import 'package:mhu_dart_ide/src/widgets/paginate.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../op.dart';
import '../op_registry.dart';

part 'menu.freezed.dart';

@freezedStruct
class MenuBuilder
    with _$MenuBuilder, ColumnWidgetBuilder, HasColumnBits, HasAppBits {
  MenuBuilder._();

  factory MenuBuilder({
    required ColumnWidgetParent parent,
    String? label,
    required List<MenuItemBits> Function(
      ColumnWidgetBits widgetBits,
    ) watchItems,
  }) = _MenuBuilder;

  late final controller = paginatorBuilder.controller;

  HasSizedWidget itemLabel(String label) {
    return ui.itemText.text(label);
  }

  HasSizedWidget itemKeys({
    required Keys? keys,
    required int pressedCount,
  }) {
    return ui.sizedKeys(
      keys: keys,
      pressedCount: pressedCount,
    );
  }

  HasSizedWidget menuItem({
    required HasSizedWidget label,
    required HasSizedWidget keys,
    Object? widgetKey,
  }) {
    const itemPadding = 1.0;

    return sizedRow(children: [
      keys.withPadding(all: itemPadding),
      label.withPadding(all: itemPadding).expanded,
    ]).withPadding(all: itemPadding);
  }

  late final itemHeight = menuItem(
    label: itemLabel(""),
    keys: itemKeys(
      keys: null,
      pressedCount: 0,
    ),
  ).height;

  late final paginatorBuilder = PaginatorBuilder(
    parent: parent,
    linker: () {
      final items = watchItems(widgetBits);

      return (disposers) {
        final handles = items.map((itemBits) {
          return (
            widgetKey: itemBits.widgetKey,
            label: itemLabel(itemBits.label),
            state: opReg.register(
              action: itemBits.action,
              disposers: disposers,
            )
          );
        }).toList();

        return PaginatorBits(
          itemHeight: itemHeight,
          itemCount: handles.length,
          itemBuilder: (from, count) {
            final pressedCount = parent.opScreen.pressedCount();
            final subHandles = handles.sublist(from, from + count);

            final widgets = subHandles.map((e) {
              return (
                widgetKey: e.widgetKey,
                label: e.label,
                keys: itemKeys(
                  keys: e.state(),
                  pressedCount: pressedCount,
                ),
              );
            }).toList();

            final keysWidth = widgets.map((e) => e.keys.width).maxOrNull ?? 0;

            return widgets.map(
              (e) => menuItem(
                widgetKey: e.widgetKey,
                label: e.label,
                keys: e.keys.constrain(
                  minWidth: keysWidth,
                ),
              ).widget,
            );
          },
        );
      };
    },
  );

  @override
  late final widget = paginatorBuilder.widget;
}

@freezedStruct
class MenuItemBits with _$MenuItemBits {
  MenuItemBits._();

  factory MenuItemBits({
    required String label,
    String? value,
    required WatchAct action,
    @Default(constantFalse) Watch<bool> isSelected,
    Object? widgetKey,
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
        return Act.act(() {
          appBits.columnBits.value = widgetBits;
        });
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
