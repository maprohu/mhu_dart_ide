import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';

import 'package:mhu_dart_ide/src/bx/paginate.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';
import 'package:recase/recase.dart';

import '../../proto.dart';
import '../builder/shaft.dart';
import '../builder/sized.dart';
import '../bx/shortcut.dart';
import '../screen/calc.dart';
import '../theme.dart';
import 'boxed.dart';
import '../sharing_box.dart';

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
  SharingBoxes menu({
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
    ).toSingleElementIterable;
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
    FutureOr<MdiInnerStateMsg> Function()? innerState,
    bool autoFocus = false,
  }) {
    final newShaftMessage = MdiShaftMsg()
      ..parent = shaftMsg
      ..shaftIdentifier = shaftIdentifier
      ..freeze();

    final callback = () {
      if (innerState != null) {
        accessInnerStateRight((innerStateFw) async {
          innerStateFw.value = await innerState();
        });
      }

      stateFw.deepRebuild((message) {
        message.topShaft = newShaftMessage;

        if (autoFocus) {
          message.ensureFocusedShaft().indexFromLeft =
              shaftCalcChain.shaftIndexFromLeft + 1;
        }
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
    ShaftIdentifier shaftIdentifier, {
    FutureOr<MdiInnerStateMsg> Function()? innerState,
    bool autoFocus = false,
  }) {
    return openerShortcutFromBits(
      openerBits(
        shaftIdentifier,
        innerState: innerState,
        autoFocus: autoFocus,
      ),
    );
  }

  MenuItem opener(
    ShaftIdentifier shaftIdentifier, {
    String? label,
  }) {
    final newShaftMessage = MdiShaftMsg()
      ..parent = shaftMsg
      ..shaftIdentifier = shaftIdentifier
      ..freeze();

    final calc = ComposedShaftCalcChain.appBits(
      appBits: this,
      shaftMsg: newShaftMessage,
      shaftIndexFromRight: 0,
      stateMsg: MdiStateMsg.getDefault(),
    ).calc;

    label ??= calc.shaftHeaderLabel;

    final bits = openerBits(
      shaftIdentifier,
      innerState: calc.shaftInitState,
      autoFocus: calc.shaftAutoFocus,
    );

    return MenuItem(
      label: label,
      callback: bits.shortcutCallback,
      openerState: bits.openerState,
    );
  }
}
