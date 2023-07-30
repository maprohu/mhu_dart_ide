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
      keys: (chars: " "),
      pressedCount: 0,
    ),
  ).height;

  late final paginatorBuilder = PaginatorBuilder(
    parent: parent,
    linker: () {
      final items = watchItems(widgetBits);

      return (disposers) {
        return PaginatorBits(
          itemHeight: itemHeight,
          itemCount: items.length,
          itemBuilder: (from, count, disposers) {
            // final List<
            //     ({
            //       HasSizedWidget label,
            //       OpState state,
            //       Object? widgetKey,
            //     })> handles = [];

            final handles = opReg.registerMany(
              disposers: disposers,
              actions: items.sublist(from, from + count).map((itemBits) {
                return (
                  itemBits.action,
                  (state) {
                    return (
                      widgetKey: itemBits.widgetKey,
                      label: itemLabel(itemBits.label),
                      state: state,
                    );
                  },
                );
              }).toList(),
            );

            HasSizedWidget keyWidget(OpState state) {
              final pressedCount = parent.opScreen.pressedCount();
              return itemKeys(
                keys: state(),
                pressedCount: pressedCount,
              );
            }

            final maxWidth = disposers.fr(() {
              return handles
                      .map(
                        (e) => keyWidget(e.state).width,
                      )
                      .maxOrNull ??
                  0;
            });

            return handles.map(
              (e) => menuItem(
                widgetKey: e.widgetKey,
                label: e.label,
                keys: SizedWidget.zero(
                  flcFrr(() {
                    return keyWidget(e.state)
                        .sizedBox(width: maxWidth())
                        .widget;
                  }),
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
