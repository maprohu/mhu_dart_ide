import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen/editing.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map.dart';
import 'package:mhu_dart_ide/src/shaft/proto/message.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import '../../builder/shaft.dart';
import '../../builder/sized.dart';
import '../../bx/menu.dart';
import '../../screen/calc.dart';
import '../../bx/boxed.dart';

part 'concrete_field.g.has.dart';
// part 'concrete_field.g.compose.dart';


class PfeConcreteFieldShaftCalc extends ShaftCalc with DelegateShaftCalcOptions implements HasEditingValueVariant {
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
  late final buildShaftContent = (sizedBits) {
    return sizedBits.fill();
  };

  late final fieldOptions = switch (access) {
    MapFieldAccess() && final o => MapFieldOptions(this, o),
    _ => _TodoOptions(this),
  };

  @override
  late final optionsDelegate = fieldOptions.options;

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

@Has()
abstract class ConcreteFieldVariant {}