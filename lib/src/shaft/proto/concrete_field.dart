import 'package:mhu_dart_ide/src/shaft/proto/field/map.dart';
import 'package:mhu_dart_ide/src/shaft/proto/message.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import '../../builder/shaft.dart';
import '../../builder/sized.dart';
import '../../bx/menu.dart';
import '../../screen/calc.dart';
import '../../bx/boxed.dart';

class PfeConcreteFieldShaftCalc extends ShaftCalc with DelegateShaftCalcOptions {
  PfeConcreteFieldShaftCalc(
    super.shaftCalcChain,
  );

  late final messageShaftCalc = leftCalc as ProtoMsgShaftCalc;

  late final shaftValue = shaftMsg.pfeConcreteField;

  late final mfw = messageShaftCalc.mfw;

  late final fieldKey = ConcreteFieldKey(
    messageType: mfw.read().runtimeType,
    tagNumber: shaftValue.tagNumber,
  );

  late final fieldCalc = fieldKey.calc;

  late final access = fieldCalc.access;

  @override
  String get label => fieldCalc.protoName;

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    return sizedBits.fill();
  }

  @override
  late final optionsDelegate = switch (access) {
    MapFieldAccess() && final o => MapFieldOptions(this, o).options,
    _ => _TodoOptions(this).options,
  };

}

abstract class ConcreteFieldOptions {
  final PfeConcreteFieldShaftCalc shaftCalc;

  ConcreteFieldOptions(this.shaftCalc);

  List<MenuItem> options(ShaftBuilderBits shaftBits);
}

class _TodoOptions extends ConcreteFieldOptions {
  _TodoOptions(super.shaftCalc);

  @override
  List<MenuItem> options(ShaftBuilderBits nodeBits) {
    return [];
  }
}
