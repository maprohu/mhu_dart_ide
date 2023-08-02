import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';

class ShaftCalcChain with HasParent<ShaftCalcChain> {
  final MdiAppBits appBits;
  final MdiShaftMsg shaftMsg;

  @override
  late final ShaftCalcChain? parent = shaftMsg.parentOpt?.let((parent) {
    return ShaftCalcChain(appBits: appBits, shaftMsg: parent);
  });

  late final ShaftCalc calc = calculateShaft(this);

  ShaftCalcChain({
    required this.appBits,
    required this.shaftMsg,
  });
}

mixin ShaftCalc {}

ShaftCalc calculateShaft(ShaftCalcChain chain) {
  final type = chain.shaftMsg.type;

  return switch (type) {
    _ => throw type,
  };
}
