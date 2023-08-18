import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/static.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';

import 'package:mhu_dart_ide/src/bx/paginate.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';

import '../../proto.dart';
import '../builder/shaft.dart';
import '../builder/sized.dart';
import '../bx/shortcut.dart';
import '../screen/calc.dart';
import '../theme.dart';
import 'boxed.dart';
import '../sharing_box.dart';
import 'menu_dynamic.dart';

part 'menu.freezed.dart';

@freezedStruct
class MenuItem with _$MenuItem {
  MenuItem._();

  factory MenuItem({
    required String label,
    required ShortcutCallback callback,
    @Default(OpenerState.closed) OpenerState openerState,
  }) = _MenuItem;
}

SharingBox menuSharingBx({
  required SizedShaftBuilderBits sizedBits,
  required int itemCount,
  required Bx Function(int index, SizedShaftBuilderBits sizedBits) itemBuilder,
  SharingBox? emptyBx,
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

  final MenuItem(
    :openerState,
  ) = menuItem;

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
    backgroundColor: sizedBits.openerBackgroundColor(openerState),
  );
}

extension MenuShaftSizedBitsX on SizedShaftBuilderBits {
  SharingBox menu(
    List<MenuItem> items,
  ) {
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

  SharingBox dynamicMenu(
    List<DynamicMenuItem> items,
  ) {
    return menuSharingBx(
      sizedBits: this,
      itemCount: items.length,
      itemBuilder: (index, sizedBits) {
        return dynamicMenuItemBx(
          menuItem: items[index],
          sizedBits: sizedBits,
        );
      },
    );
  }
}

extension MenuShaftBuilderBitsX on ShaftBuilderBits {
  Color? openerBackgroundColor(OpenerState openerState) {
    if (openerState == OpenerState.open) {
      return themeCalc.openItemColor;
    }

    return null;
  }

  // Color? openerFieldBackgroundColor(
  //   ScalarFieldAccess<MdiShaftMsg, dynamic> access,
  // ) {
  //   return openerBackgroundColor(
  //     isOpen: access.has,
  //   );
  // }

  // MenuItem openerField<T extends GeneratedMessage>(
  //   MessageFieldAccess<MdiShaftMsg, T> access, {
  //   void Function(T shaftTypeMsg) updateShaft = ignore1,
  //   void Function(MdiShaftMsg shaftMsg) before = ignore1,
  //   bool autoFocus = false,
  //   String? label,
  //   bool Function(MdiShaftMsg rightShaft)? isOpen,
  // }) {
  //   final shaftType = access.defaultSingleValue.rebuild(updateShaft);
  //   return opener(
  //     (shaft) {
  //       access.set(
  //         shaft,
  //         shaftType,
  //       );
  //     },
  //     before: before,
  //     label: label ?? access.name.titleCase,
  //     autoFocus: autoFocus,
  //     isOpen: isOpen ?? (shaftMsg) => access.getOpt(shaftMsg) == shaftType,
  //   );
  // }

  OpenerBits openerBits(
    ShaftIdentifier shaftIdentifier, {
    MdiInnerStateMsg? innerState,
    OnShaftOpen onShaftOpen = noop,
  }) {
    final newShaftMessage = MdiShaftMsg$.create(
      parent: shaftMsg,
      shaftIdentifier: shaftIdentifier,
      innerState: innerState,
    )..freeze();

    final callback = () {
      // if (initInnerState != null) {
      //   accessInnerStateRight((innerStateFw) async {
      //     innerStateFw.value = await initInnerState();
      //   });
      // }

      txn(() {
        stateFw.rebuild((message) {
          message.topShaft = newShaftMessage;
        });

        onShaftOpen();
      });
    };

    return ComposedOpenerBits(
      openerState: shaftDoubleChain.shaftDoubleChainRight?.shaftCalcChain
                  .shaftMsg.shaftIdentifier ==
              shaftIdentifier
          ? OpenerState.open
          : OpenerState.closed,
      shortcutCallback: callback,
    );
  }

  Bx openerShortcut(
    ShaftIdentifier shaftIdentifier,
    // {
    //   // FutureOr<MdiInnerStateMsg> Function()? innerState,
    // }
  ) {
    return openerShortcutFromBits(
      openerBits(
        shaftIdentifier,
        // initInnerState: innerState,
      ),
    );
  }

  MenuItem opener(
    ShaftIdentifier shaftIdentifier, {
    String? label,
    MdiInnerStateMsg? innerState,
  }) {
    final newShaftMessage = MdiShaftMsg$.create(
      parent: shaftMsg,
      shaftIdentifier: shaftIdentifier,
      innerState: innerState,
    )..freeze();

    final calc = ComposedShaftCalcChain.appBits(
      appBits: this,
      shaftMsg: newShaftMessage,
      shaftIndexFromRight: 0,
      stateMsg: MdiStateMsg.getDefault(),
    ).calc;

    label ??= calc.shaftHeaderLabel;

    final bits = openerBits(
      shaftIdentifier,
      onShaftOpen: calc.onShaftOpen,
      // initInnerState: calc.shaftInitState,
    );

    return MenuItem(
      label: label,
      callback: bits.shortcutCallback,
      openerState: bits.openerState,
    );
  }
}
