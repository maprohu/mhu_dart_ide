import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_ide/src/shaft/proto/message.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

Bx mdiConfigMenuShaftBx({
  required SizedNodeBuilderBits sizedBits,
  required MdiConfigShaftMsg value,
}) {
  return mdiProtoMsgShaftBx(
    sizedBits: sizedBits,
    mfw: sizedBits.configBits.config,
  );
}
