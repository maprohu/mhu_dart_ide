import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/shaft.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

Bx mdiConfigMenuShaftBx({
  required SizedNodeBuilderBits sizedBits,
  required MdiConfigShaftMsg value,
}) {
  return sizedBits.menuShaft(
    label: "config",
    items: [],
  );
}
