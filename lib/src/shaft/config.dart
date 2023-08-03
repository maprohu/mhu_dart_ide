import 'package:mhu_dart_ide/src/shaft/proto/message.dart';

class ConfigShaftCalc extends ProtoMsgShaftCalc {
  ConfigShaftCalc(super.shaftCalcChain)
      : super(
          mfw: shaftCalcChain.configBits.config,
        );
}
