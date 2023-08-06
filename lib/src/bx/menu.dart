import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';

import 'package:mhu_dart_ide/src/bx/paginate.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:recase/recase.dart';

import '../../proto.dart';
import '../builder/shaft.dart';
import '../builder/sized.dart';
import '../bx/shortcut.dart';
import '../screen/calc.dart';
import '../theme.dart';
import 'boxed.dart';
import 'share.dart';

part 'menu.freezed.dart';

@freezedStruct
class MenuItem with _$MenuItem {
  MenuItem._();

  factory MenuItem({
    required String label,
    required ShortcutCallback callback,
  }) = _MenuItem;
}

SharingBx menuSharingBx({
  required SizedShaftBuilderBits sizedBits,
  required int itemCount,
  required Bx Function(int index, SizedShaftBuilderBits sizedBits) itemBuilder,
  SharingBx? emptyBx,
}) {
  final SizedShaftBuilderBits(
    :themeCalc,
  ) = sizedBits;

  final ThemeCalc(
    :menuItemHeight,
    :menuItemsDividerThickness,
  ) = themeCalc;

  return paginatorAlongYSharingBx(
    sizedBits: sizedBits,
    itemHeight: menuItemHeight,
    itemCount: itemCount,
    itemBuilder: itemBuilder,
    dividerThickness: menuItemsDividerThickness,
    startAt: 0,
    emptyBx: emptyBx,
  );
}

Bx menuItemBx({
  required MenuItem menuItem,
  required SizedShaftBuilderBits sizedBits,
}) {
  final themeCalc = sizedBits.themeCalc;

  return sizedBits.padding(
    padding: themeCalc.menuItemPadding,
    builder: (sizedBits) {
      final MenuItem(
        :callback,
        :label,
      ) = menuItem;

      return sizedBits.fillRight(
        left: sizedBits.centerHeight(
          sizedBits.shortcut(callback),
        ),
        right: (sizedBits) {
          return sizedBits.itemText.centerLeft(label);
        },
      );
    },
  );
}

extension MenuShaftSizedBitsX on SizedShaftBuilderBits {
  SharingBx menu({
    required List<MenuItem> items,
  }) {
    return menuSharingBx(
      sizedBits: this,
      itemCount: items.length,
      itemBuilder: (index, sizedBits) {
        return menuItemBx(
          menuItem: items[index],
          sizedBits: sizedBits,
        );
      },
    );
  }
}

// extension MenuHasShaftBitsX on HasShaftBuilderBits {
//   MenuItem openerField(ScalarFieldAccess<MdiShaftMsg, dynamic> access) =>
//       shaftBits.openerField(access);
//
//   MenuItem opener(
//     ShaftOpener builder, {
//     String? label,
//   }) =>
//       shaftBits.opener(
//         builder,
//         label: label,
//       );
// }

extension MenuShaftBitsX on ShaftBuilderBits {
  MenuItem openerField(ScalarFieldAccess<MdiShaftMsg, dynamic> access) {
    return opener(
      (shaft) {
        access.set(shaft, access.defaultSingleValue);
      },
      label: access.name.titleCase,
    );
  }

  MenuItem opener(
    ShaftOpener builder, {
    String? label,
  }) {
    label ??= ComposedShaftCalcChain.appBits(
      appBits: this,
      shaftMsg: MdiShaftMsg().also(builder)..freeze(),
      shaftIndexFromRight: 0,
    ).calc.shaftHeaderLabel;

    return MenuItem(
      label: label,
      callback: openerCallback(builder),
    );
  }
}
