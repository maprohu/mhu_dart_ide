import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/bx/shortcut.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/model.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

import '../../proto.dart';
import '../builder/shaft.dart';
import '../bx/boxed.dart';

part 'opener.g.has.dart';

part 'opener.g.compose.dart';

typedef ShaftOpener = void Function(MdiShaftMsg shaft);


@Has()
enum OpenerState {
  closed,
  open,
}

@Compose()
abstract class OpenerBits implements HasOpenerState, HasShortcutCallback {}

// extension ScreenHasShaftBuilderBitsX on HasShaftBuilderBits {
//   VoidCallback openerCallback(ShaftOpener builder) =>
//       shaftBits.openerCallback(builder);
// }

// extension ScreenShaftBuilderBitsX on ShaftBuilderBits {
//   VoidCallback openerCallback(
//     ShaftOpener builder, {
//     void Function(MdiShaftMsg shaftMsg) before = ignore1,
//     int? focusShaftIndexFromLeft,
//   }) {
//     return () {
//       final newShaft = MdiShaftMsg$.create(
//         parent: shaftMsg.clearNotificationsDeepRebuild(),
//       ).also(builder)
//         ..freeze();
//
//       before(newShaft);
//
//       stateFw.deepRebuild((message) {
//         message.topShaft = newShaft;
//         if (focusShaftIndexFromLeft != null) {
//           message.ensureFocusedShaft().indexFromLeft = focusShaftIndexFromLeft;
//         }
//       });
//     };
//   }
// }

extension OpenerShaftCalcBitsX on HasShaftCalcChain {
  void closeShaft() {
    shaftCalcChain.stateFw.rebuild((message) {
      message.topShaft = message.topShaft
          .shaftByIndexFromLeft(shaftCalcChain.shaftIndexFromLeft - 1)!;
    });
  }
}

typedef ShaftIdentifier = MdiShaftIdentifierMsg;
// @freezed
// class ShaftIdentifier
//     with _$ShaftIdentifier
//     implements HasShaftType, HasShaftKey {
//   const factory ShaftIdentifier(
//     ShaftType shaftType, {
//     ShaftKey shaftKey,
//   }) = _ShaftIdentifier;
// }

typedef ShaftKey<T> = void Function(T key)?;

typedef ShaftTypeField<M extends GeneratedMessage>
    = MessageFieldAccess<MdiShaftIdentifierMsg, M>;

extension ShaftIdentifierShaftTypeX<M extends GeneratedMessage>
    on ShaftTypeField<M> {
  ShaftIdentifier shaftIdentifier([ShaftKey<M> shaftKey]) {
    final msg = ShaftIdentifier();
    final type = ensureAttribute(msg);
    if (shaftKey != null) {
      shaftKey(type);
    }
    return msg..freeze();
  }

  OpenerBits openerCallback(
    ShaftBuilderBits shaftBuilderBits, {
    ShaftKey shaftKey,
  }) {
    return shaftBuilderBits.openerBits(
      shaftIdentifier(shaftKey),
    );
  }

  MenuItem opener(
      ShaftBuilderBits shaftBuilderBits, {
        ShaftKey<M> shaftKey,
        FutureOr<MdiInnerStateMsg> Function()? innerState,
      }) {
    return shaftBuilderBits.opener(
      shaftIdentifier(shaftKey),
      innerState: innerState,
    );
  }

  Bx openerShortcut(
    ShaftBuilderBits shaftBuilderBits, {
    ShaftKey<M> shaftKey,
    FutureOr<MdiInnerStateMsg> Function()? innerState,
  }) {
    return shaftBuilderBits.openerShortcut(
      shaftIdentifier(shaftKey),
      innerState: innerState,
    );
  }
}
