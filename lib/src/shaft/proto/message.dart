import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:protobuf/protobuf.dart';

import '../../screen.dart';
import '../../widgets/boxed.dart';

Bx mdiProtoMsgShaftBx({
  required SizedNodeBuilderBits sizedBits,
  required Mfw mfw,
}) {
  final calc = mfw.read().pbi.calc;

  return sizedBits.menuShaft(
    label: calc.messageType.toString(),
    items: calc.topFieldKeys.map((fieldKey) {
      switch (fieldKey) {
        case ConcreteFieldKey():
          return sizedBits.opener(
            label: fieldKey.calc.protoName,
            builder: (shaft) {
              shaft.ensurePfeConcreteField().tagNumber =
                  fieldKey.tagNumber;
            },
          );
        case OneofFieldKey():
          return sizedBits.opener(
            label: fieldKey.calc.name,
            builder: (shaft) {
              shaft.ensurePfeOneofField().oneofIndex =
                  fieldKey.oneofIndex;
            },
          );
      }
    }).toList(),
  );
}

extension PfeMessageShaftX on MdiShaftMsg {
  Mfw mfw(MdiAppBits appBits) => switch (type) {
    MdiShaftMsg_Type$config() => appBits.config,
    _ => throw type,
  };

}