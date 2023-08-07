import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/state.dart';
import 'package:mhu_dart_ide/src/theme.dart';

import '../app.dart';
import '../config.dart';
import '../op.dart';
import 'double.dart';
import 'sized.dart';

part 'shaft.g.compose.dart';

@Compose()
abstract class ShaftBuilderBits implements HasShaftDoubleChain, ShaftCalc {}

extension ShaftBuilderBitsX on ShaftBuilderBits {
  ThemeCalc get themeCalc => themeCalcFr();

  StateCalc get stateCalc => stateCalcFr();

  SizedShaftBuilderBits sized(Size size) =>
      ComposedSizedShaftBuilderBits.shaftBuilderBits(
        shaftBuilderBits: this,
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
