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
import '../../widgets/boxed.dart';

Bx mdiPfeConcreteFieldShaftBx({
  required SizedNodeBuilderBits sizedBits,
  required MdiPfeConcreteFieldShaftMsg value,
}) {
  final mfw = sizedBits.shaftMsg.parent.mfw(sizedBits.appBits);

  final fieldKey = ConcreteFieldKey(
    messageType: mfw.read().runtimeType,
    tagNumber: value.tagNumber,
  );
  final calc = fieldKey.calc;
  final access = calc.access;

  final ShaftBuilder? shaftBuilder = switch (access) {
    MapFieldAccess() => mdiPfeMapFieldShaftBuilder(),
    _ => null,
  };

  if (shaftBuilder == null) {
    return errorShaftBx(
      sizedBits: sizedBits,
      message: "no shaft: ${calc.access.runtimeType}",
    );
  }

  return sizedBits.shaft((headerBits, contentBits) {
    return ShaftParts(
      header: headerBits.headerText.centerLeft(calc.protoName),
      content: contentBits.fill(),
    );
  });
}
