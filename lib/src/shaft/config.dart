// import 'package:mhu_dart_ide/src/shaft/proto/message.dart';
// import 'package:mhu_dart_ide/src/shaft/switch.dart';
//
// final ShaftCalcBuilder configShaftCalc =
//     (shaftCalcBuildBits) => PfeMessageShaftCalc.of(
//           shaftCalcBuildBits: shaftCalcBuildBits,
//           mfw: shaftCalcBuildBits.configFw,
//         );

import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_ide/src/shaft/proto/message.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

part 'config.g.has.dart';

part 'config.g.compose.dart';

@Has()
@Compose()
abstract class ConfigShaftRight
    implements HasMessageEditingBits<MdiConfigMsg> {}

@Compose()
abstract class ConfigShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class ConfigShaft
    implements
        ShaftCalcBuildBits,
        ConfigShaftMerge,
        ConfigShaftRight,
        ShaftCalc {
  static ConfigShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final messageEditingBits = MessageEditingBits.create(
      editingFw: shaftCalcBuildBits.configFw,
      messageDataType:
          shaftCalcBuildBits.configFw.read().pbi.calc.messageDataType,
    );

    final messageBits = PfeMessageBits.create(
      messageEditingBits: messageEditingBits,
    );

    final shaftRight = ComposedConfigShaftRight(
      messageEditingBits: messageEditingBits,
    );
    final shaftMerge = ComposedConfigShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: messageBits.buildShaftContent,
    );

    return ComposedConfigShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      configShaftMerge: shaftMerge,
      configShaftRight: shaftRight,
    );
  }
}
