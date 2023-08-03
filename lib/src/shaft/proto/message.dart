import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:recase/recase.dart';
import '../../builder/sized.dart';
import '../../bx/boxed.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

class ProtoMsgShaftCalc extends ShaftCalc {
  final Mfw mfw;

  ProtoMsgShaftCalc(
    super.shaftCalcChain, {
    required this.mfw,
  });

  late final pbi = mfw.read().pbi;

  late final messageCalc = pbi.calc;

  @override
  String get label => messageCalc.messageName.titleCase;

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    final calc = mfw.read().pbi.calc;
    return sizedBits.menu(
      items: calc.topFieldKeys.map((fieldKey) {
        switch (fieldKey) {
          case ConcreteFieldKey():
            return sizedBits.opener(
              (shaft) {
                shaft.ensurePfeConcreteField().tagNumber = fieldKey.tagNumber;
              },
              label: fieldKey.calc.protoName,
            );
          case OneofFieldKey():
            return sizedBits.opener(
              (shaft) {
                shaft.ensurePfeOneofField().oneofIndex = fieldKey.oneofIndex;
              },
              label: fieldKey.calc.name,
            );
        }
      }).toList(),
    );
  }
}


