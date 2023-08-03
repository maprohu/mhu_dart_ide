import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';

import '../../proto.dart';
import '../screen.dart';
import '../shaft.dart';

extension ScreenHasShaftBuilderBitsX on HasShaftBuilderBits {

  VoidCallback openerCallback(ShaftOpener builder) => () {
    configBits.state.rebuild((message) {
      message.topShaft = MdiShaftMsg$.create(
        parent: shaftMsg,
      ).also(builder);
    });
  };
}
