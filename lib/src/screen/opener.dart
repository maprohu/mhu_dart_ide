import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';

import '../../proto.dart';
import '../builder/shaft.dart';

typedef ShaftOpener = void Function(MdiShaftMsg shaft);

// extension ScreenHasShaftBuilderBitsX on HasShaftBuilderBits {
//   VoidCallback openerCallback(ShaftOpener builder) =>
//       shaftBits.openerCallback(builder);
// }

extension ScreenShaftBuilderBitsX on ShaftBuilderBits {
  VoidCallback openerCallback(ShaftOpener builder) => () {
        stateFw.rebuild((message) {
          message.topShaft = MdiShaftMsg$.create(
            parent: shaftMsg,
          ).also(builder);
        });
      };
}
