import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_ide/src/shaft/error.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map.dart';
import 'package:mhu_dart_ide/src/shaft/proto/message.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:protobuf/protobuf.dart';

import '../../screen.dart';
import '../../screen/calc.dart';
import '../../widgets/boxed.dart';

class PfeConcreteFieldShaftCalc extends ShaftCalc {
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

  late final _options = switch (access) {
    MapFieldAccess() && final o => MapFieldOptions(this, o),
    _ => _TodoOptions(this),
  };

  @override
  List<MenuItem> options(ShaftBuilderBits nodeBits) => _options.options(nodeBits);

}

abstract class ConcreteFieldOptions {
  final PfeConcreteFieldShaftCalc shaftCalc;

  ConcreteFieldOptions(this.shaftCalc);

  List<MenuItem> options(ShaftBuilderBits nodeBits);

}

class _TodoOptions extends ConcreteFieldOptions {
  _TodoOptions(super.shaftCalc);

  @override
  List<MenuItem> options(ShaftBuilderBits nodeBits) {
    return [];
  }

}
