import 'package:mhu_dart_ide/src/shaft/proto/message.dart';
import 'package:mhu_dart_ide/src/shaft/switch.dart';

final ShaftCalcBuilder configShaftCalc =
    (shaftCalcChain) => PfeMessageShaftCalc.of(
          shaftCalcChain: shaftCalcChain,
          mfw: shaftCalcChain.configFw,
        );
