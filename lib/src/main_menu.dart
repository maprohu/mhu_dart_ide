import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_dart_ide/src/ops/build_runner.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/menu.dart';

ColumnWidgetBits mdiMainMenu({
  required ColumnWidgetParent parent,
}) {
  return MenuBuilder(
    parent: parent,
    watchItems: (widgetBits) {
      return [
        widgetBits.opener(
          label: "build_runner",
          builder: (parent) {
            return mdiBuildRunnerMenu(
              parent: parent,
            );
          },
        ),
        ...Iterable.generate(35, identity).map((index) {
          return MenuItemBits(
            label: "$index",
            action: () {
              return Act.act(() {});
            },
          );
        }),
      ];
    },
  ).widgetBits;
}
