import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/context/app.dart';
import 'package:mhu_shafts/src/keyboard.dart';

import 'config.dart' as $lib;

part 'config.g.has.dart';

part 'config.g.dart';

@Has()
typedef ConfigMsg = MshConfigMsg;

@Compose()
abstract class ConfigWrap implements HasConfigMsg, HasDataCtx {
}

ConfigWrap createConfigWrap({
  @Ext() required DataCtx dataCtx,
  required ConfigMsg configMsg,
}) {
  return ComposedConfigWrap(
    dataCtx: dataCtx,
    configMsg: configMsg,
  );
}
