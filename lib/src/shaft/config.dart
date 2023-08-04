import 'package:mhu_dart_ide/src/shaft/proto/message.dart';
import 'package:mhu_dart_ide/src/shaft/switch.dart';


final ShaftCalcBuilder configShaftCalc =
    (shaftCalcChain) => buildMfwShaftCalc(
          shaftCalcChain,
          shaftCalcChain.configFw,
        );
