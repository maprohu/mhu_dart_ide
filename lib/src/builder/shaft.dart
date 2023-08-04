import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

import '../app.dart';
import '../op.dart';
import 'double.dart';
import 'sized.dart';

part 'shaft.freezed.dart';

@freezedStruct
class ShaftBuilderBits
    with
        _$ShaftBuilderBits,
        HasShaftDoubleChain,
        HasShaftCalc,
        HasShaftCalcChain,
        HasShaftMsg {
  ShaftBuilderBits._();

  factory ShaftBuilderBits({
    required AppBits appBits,
    required OpBuilder opBuilder,
    required ShaftDoubleChain doubleChain,
  }) = _ShaftBuilderBits;

  late final configBits = appBits.configBits;

  late final themeCalc = configBits.themeCalcFr();
  late final stateCalc = configBits.stateCalcFr();

  SizedShaftBuilderBits sized(Size size) => SizedShaftBuilderBits(
        shaftBits: this,
        size: size,
      );

  SizedShaftBuilderBits sizedFrom({
    required double width,
    required double height,
  }) =>
      sized(
        Size(width, height),
      );
}

mixin HasShaftBuilderBits {
  ShaftBuilderBits get shaftBits;

  late final appBits = shaftBits.appBits;

  late final opBuilder = shaftBits.opBuilder;
  late final configBits = shaftBits.configBits;
  late final themeCalc = shaftBits.themeCalc;
  late final stateCalc = shaftBits.stateCalc;

  late final shaftMsg = shaftBits.shaftMsg;
}


