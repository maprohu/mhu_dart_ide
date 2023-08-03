import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:recase/recase.dart';

import '../builder/sized.dart';
import '../bx/menu.dart';
import '../shaft/switch.dart';
import '../bx/boxed.dart';

class ShaftCalcChain with HasParent<ShaftCalcChain>, HasAppBits, HasShaftMsg {
  @override
  final MdiAppBits appBits;
  @override
  final MdiShaftMsg shaftMsg;

  @override
  late final ShaftCalcChain? parent = shaftMsg.parentOpt?.let((parent) {
    return ShaftCalcChain(
      appBits: appBits,
      shaftMsg: parent,
    );
  });

  late final ShaftCalc calc = calculateShaft(this);

  ShaftCalcChain({
    required this.appBits,
    required this.shaftMsg,
  });
}

mixin HasShaftMsg {
  MdiShaftMsg get shaftMsg;

  late final shaftWidth = shaftMsg.widthOpt ?? 1;
}

mixin HasShaftCalcChain {
  ShaftCalcChain get shaftCalcChain;

  late final shaftMsg = shaftCalcChain.shaftMsg;
}

abstract class ShaftCalc with HasShaftCalcChain, HasShaftMsg {
  @override
  final ShaftCalcChain shaftCalcChain;
  final String staticLabel;

  List<MenuItem> options(ShaftBuilderBits shaftBits) => const [];

  Bx content(SizedShaftBuilderBits sizedBits);

  ShaftCalc(
    this.shaftCalcChain, {
    this.staticLabel = "<no label>",
  });

  ShaftCalc.access(
    this.shaftCalcChain, {
    required ScalarFieldAccess<MdiShaftMsg, dynamic> access,
  }) : staticLabel = access.name.titleCase;

  String get label => staticLabel;

  late final leftCalc = shaftCalcChain.parent?.calc;
}

mixin HasShaftCalc {
  ShaftCalc get shaftCalc;

  late final shaftCalcChain = shaftCalc.shaftCalcChain;
}

mixin DelegateShaftCalcOptions {
  List<MenuItem> Function(ShaftBuilderBits shaftBits) get optionsDelegate;

  List<MenuItem> options(ShaftBuilderBits shaftBits) =>
      optionsDelegate(shaftBits);
}
