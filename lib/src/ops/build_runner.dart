import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/menu.dart';

import '../op.dart';

const buildRunnerOp = Op(
  label: "Build Runner",
);

ColumnWidgetBits mdiBuildRunnerMenu({
  required ColumnWidgetParent parent,
}) {
  return MenuBuilder(
    parent: parent,
    watchItems: (widgetBits) {
      return [
        widgetBits.opener(
          label: "Settings",
          builder: (parent) {
            throw "todo";
          },
        )
      ];
    },
  ).widgetBits;
}
