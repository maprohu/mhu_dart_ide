import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';
import 'package:recase/recase.dart';
import '../../app.dart';
import '../../builder/sized.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

import '../../config.dart';
import '../../op.dart';

// part 'message.g.has.dart';
part 'message.g.compose.dart';

@Compose()
abstract class PfeMessageShaftCalc implements ShaftCalcBuildBits, ShaftCalc, HasMfw {
  static PfeMessageShaftCalc of({
    required ShaftCalcBuildBits shaftCalcBuildBits,
    required Mfw mfw,
  }) {
    late final pbi = mfw.read().pbi;

    late final messageCalc = pbi.calc;

    return ComposedPfeMessageShaftCalc.shaftCalcBuildBits(
      shaftCalcBuildBits: shaftCalcBuildBits,
      shaftHeaderLabel: messageCalc.messageName.titleCase,
      buildShaftContent: (SizedShaftBuilderBits sizedBits) {
        return sizedBits.menu(
          items: messageCalc.topFieldKeys.map((fieldKey) {
            switch (fieldKey) {
              case ConcreteFieldKey():
                return sizedBits.opener(
                  (shaft) {
                    shaft.ensurePfeConcreteField().tagNumber =
                        fieldKey.tagNumber;
                  },
                  label: fieldKey.concreteFieldCalc.protoName,
                );
              case OneofFieldKey():
                return sizedBits.opener(
                  (shaft) {
                    shaft.ensurePfeOneofField().oneofIndex =
                        fieldKey.oneofIndex;
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
}
