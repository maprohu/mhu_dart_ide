import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';

void mdiStartSerivces({
  required MdiAppBits appBits,
  required DspReg disposers,
}) {
  appBits.configBits.config.packagePaths.changes().map((list) => list.toSet());

}