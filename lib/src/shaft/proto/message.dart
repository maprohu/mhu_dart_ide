import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/shaft/switch.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:recase/recase.dart';
import '../../builder/sized.dart';
import '../../bx/boxed.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

// part 'message.g.has.dart';
part 'message.g.compose.dart';

@Compose()
abstract class MfwShaftCalc implements ShaftCalcBits, ShaftCalc, HasMfw {}

ShaftCalc buildMfwShaftCalc(ShaftCalcChain shaftCalcChain, Mfw mfw) {
  late final pbi = mfw.read().pbi;

  late final messageCalc = pbi.calc;

  return ComposedMfwShaftCalc.shaftCalcBits(
    shaftCalcBits: shaftCalcChain,
    shaftCalcChain: shaftCalcChain,
    shaftHeaderLabel: messageCalc.messageName.titleCase,
    buildShaftContent: (SizedShaftBuilderBits sizedBits) {
      return sizedBits.menu(
        items: messageCalc.topFieldKeys.map((fieldKey) {
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
    },
    mfw: mfw,
  );
}
