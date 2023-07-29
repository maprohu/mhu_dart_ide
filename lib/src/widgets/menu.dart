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

  late final controller = HwPaginatorController();

  HasSizedWidget itemLabel(String label) {
    return ui.itemText.text(label);
  }

  HasSizedWidget itemKeys(Keys? keys) {
    return ui.sizedKeys(keys);
  }

  HasSizedWidget menuItem({
    required HasSizedWidget label,
    required HasSizedWidget keys,
  }) {
    const itemPadding = 1.0;

    return sizedRow(children: [
      keys.withPadding(all: itemPadding),
      label.withPadding(all: itemPadding).expanded,
    ]).withPadding(all: itemPadding);
  }

  late final itemHeight = menuItem(
    label: itemLabel(""),
    keys: itemKeys(null),
  ).height;

  @override
  late final widget = flcFrr(() {
    final items = watchItems(widgetBits);

    return flcDsp((disposers) {
      final handles = items.map((itemBits) {
        return (
          label: itemLabel(itemBits.label),
          state: opReg.register(
            action: itemBits.action,
            disposers: disposers,
          )
        );
      }).toList();

      final itemCount = handles.length;

      return flcFrr(() {
        return hwPaginator(
          itemHeight: itemHeight,
          itemCount: itemCount,
          itemBuilder: (from, count) {
            final subHandles = handles.sublist(from, from + count);

            final widgets = subHandles.map((e) {
              return (
                label: e.label,
                keys: itemKeys(e.state()),
              );
            }).toList();

            final keysWidth = widgets.map((e) => e.keys.width).maxOrNull ?? 0;

            return widgets.map(
              (e) => menuItem(
                label: e.label,
                keys: e.keys.constrain(
                  minWidth: keysWidth,
                ),
              ).widget,
            );
          },
          ui: ui,
          controller: controller,
        );
      });
    });
  });
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
