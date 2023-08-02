import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_ide/src/widgets/paginate.dart';
import 'package:mhu_dart_ide/src/widgets/shortcut.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../screen.dart';
import '../theme.dart';
import 'boxed.dart';

PaginatorBx menuBx({
  required SizedNodeBuilderBits sizedBits,
  required int itemCount,
  required Bx Function(int index, SizedNodeBuilderBits sizedBits) itemBuilder,
}) {
  final SizedNodeBuilderBits(
    :themeCalc,
  ) = sizedBits;

  final ThemeCalc(
    :menuItemHeight,
    :menuItemsDividerThickness,
  ) = themeCalc;

  return paginatorAlongYBx(
    sizedBits: sizedBits,
    itemHeight: menuItemHeight,
    itemCount: itemCount,
    itemBuilder: itemBuilder,
    dividerThickness: menuItemsDividerThickness,
    startAt: 0,
  );
}

Bx menuItemBx({
  required MenuItem menuItem,
  required SizedNodeBuilderBits sizedBits,
}) {
  final themeCalc = sizedBits.themeCalc;

  return sizedBits.padding(
    padding: themeCalc.menuItemPadding,
    builder: (sizedBits) {
      final MenuItem(
        :callback,
        :label,
      ) = menuItem;

      return sizedBits.left(
        Bx.row([
          sizedBits.centerAlongY(
            sizedBits.nodeBits.shortcutFr(callback),
          ),
          sizedBits.centerAlongY(
            textBx(
              text: label,
              style: themeCalc.menuItemTextStyle,
            ),
          ),
        ]),
      );
    },
  );
}