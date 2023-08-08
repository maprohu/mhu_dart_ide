import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/model.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

import '../../proto.dart';
import '../builder/shaft.dart';

typedef ShaftOpener = void Function(MdiShaftMsg shaft);

// extension ScreenHasShaftBuilderBitsX on HasShaftBuilderBits {
//   VoidCallback openerCallback(ShaftOpener builder) =>
//       shaftBits.openerCallback(builder);
// }

extension ScreenShaftBuilderBitsX on ShaftBuilderBits {
  VoidCallback openerCallback(
    ShaftOpener builder, {
    void Function(MdiShaftMsg shaftMsg) before = ignore1,
  }) {
    return () {
      final newShaft = MdiShaftMsg$.create(
        parent: shaftMsg.clearNotificationsDeepRebuild(),
      ).also(builder)
        ..freeze();

      before(newShaft);

      stateFw.rebuild((message) {
        message.topShaft = newShaft;
      });
    };
  }
}

extension OpenerShaftCalcBitsX on HasShaftCalcChain {
  void closeShaft() {
    shaftCalcChain.stateFw.rebuild((message) {
      message.topShaft = message.topShaft
          .shaftByIndexFromLeft(shaftCalcChain.shaftIndexFromLeft - 1);
    });
  }
}
