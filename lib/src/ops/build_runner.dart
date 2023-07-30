import 'package:flutter/services.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_dart_ide/src/pfe/pfe.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/menu.dart';

import '../op.dart';

// const buildRunnerOp = Op(
//   label: "Build Runner",
// );

ColumnWidgetBits mdiBuildRunnerMenu({
  required ColumnWidgetParent parent,
}) {
  return MenuBuilder(
    parent: parent,
    watchItems: (widgetBits) {
      return [
        widgetBits.opener(
          label: "Packages",
          builder: (parent) {
            return mdiBuildRunnerPackagesMenu(parent: parent);
          },
        )
      ];
    },
  ).widgetBits;
}

ColumnWidgetBits mdiBuildRunnerPackagesMenu({
  required ColumnWidgetParent parent,
}) {
  return MenuBuilder(
    parent: parent,
    watchItems: (widgetBits) {
      final packages = parent.config.packagePaths();
      return [
        widgetBits.opener(
          label: "<add new>",
          builder: (parent) {
            return mdiBuildRunnerPackagesMenu(parent: parent);
          },
        ),
        for (final package in packages)
          MenuItemBits(
            label: package,
            action: () {
              return () {};
            },
          ),
      ];
    },
  ).widgetBits;
}
ColumnWidgetBits mdiBuildRunnerPackagesAddNewMenu({
  required ColumnWidgetParent parent,
}) {
  return MenuBuilder(
    parent: parent,
    watchItems: (widgetBits) {
      return [
        widgetBits.opener(
          label: "<add new>",
          builder: (parent) {
            return mdiBuildRunnerPackagesMenu(parent: parent);
          },
        ),
        for (final package in packages)
          MenuItemBits(
            label: package,
            action: () {
              return () {};
            },
          ),
      ];
    },
  ).widgetBits;
}
