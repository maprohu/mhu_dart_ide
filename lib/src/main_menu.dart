import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/menu.dart';

ColumnWidgetBits mdiMainMenu({
  required ColumnWidgetParent parent,
}) {
  return MenuBuilder(
    parent: parent,
    watchItems: (widgetBits) {
      return [

        ...Iterable.generate(35, identity).map((index) {
          return widgetBits.opener(
            label: "$index",
            builder: (parent) {
              return mdiMainMenu(
                parent: parent,
              );
            },
          );
          // return MenuItemBits(
          //   label: "$index",
          //   action: () {
          //     return Act.act(() {});
          //   },
          // );
        }),
      ];
    },
  ).widgetBits;
}
