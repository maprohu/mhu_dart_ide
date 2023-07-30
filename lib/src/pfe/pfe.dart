import 'package:flutter/cupertino.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/icons.dart';
import 'package:mhu_dart_ide/src/ui.dart';
import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_dart_ide/src/widgets/paginate.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

import '../widgets/bar.dart';

ColumnWidgetBits mdiProtoFwEditor<M extends GeneratedMessage>({
  required ColumnWidgetParent parent,
  required Fw<M> mfw,
}) {
  final ui = parent.ui;
  final pbi = mfw.read().pbi;

  final fields = pbi.calc.topFieldKeys;

  HasSizedWidget field({
    required String label,
    required String value,
    required BarBits? barBits,
    double? width,
  }) {
    return sizedRow(children: [
      sizedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ui.itemText.text(label),
          ui.itemText.text(value),
        ],
      ),
      if (barBits != null)
        barBits.widget(
          width?.let((w) => w / 2),
        ),
    ]);
  }

  final itemHeight = field(
    label: "",
    value: "",
    barBits: BarBits(
      primary: ui.sizedOpIcon(
        icon: MdiIcons.help,
        keys: null,
        pressedCount: 0,
      ),
    ),
  ).height;

  final columnBits = parent.columnBits;

  final widget = LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;

      return PaginatorBuilder(
        parent: parent,
        linker: () {
          return (disposers) {
            return PaginatorBits(
              itemHeight: itemHeight,
              itemCount: fields.length,
              itemBuilder: (from, count, disposers) {
                final sub = fields.sublist(from, from + count);

                return sub.map((element) {
                  return field(
                    label: "<field>",
                    value: "<value>",
                    barBits: null,
                    width: width,
                  ).widget;
                });
              },
            );
          };
        },
      ).widget;
    },
  );

  return ColumnWidgetBits.fromParent(
    parent: parent,
    widget: widget,
  );
}
