import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/bx/menu_dynamic.dart';
import 'package:mhu_dart_ide/src/context/config.dart';
import 'package:mhu_dart_ide/src/dart/dart_package.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/proto/content/message.dart';
import 'package:mhu_dart_ide/src/shaft/proto/proto_customizer.dart';
import 'package:mhu_dart_ide/src/shaft/proto/proto_path.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import '../long_running.dart';

part 'config.g.has.dart';

part 'config.g.compose.dart';

part 'config_custromizer.dart';

@Has()
@Compose()
abstract class ConfigShaftRight implements HasEditingBits<MdiConfigMsg> {}

@Compose()
abstract class ConfigShaft
    implements
        ShaftCalcBuildBits,
        ShaftContentBits,
        ConfigShaftRight,
        ShaftCalc {
  static ConfigShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final messageEditingBits = MessageEditingBits.create(
      messageDataType:
          shaftCalcBuildBits.configFw.read().pbi.calc.messageDataType,
      scalarValue: shaftCalcBuildBits.configFw.toScalarValue,
      protoCustomizer: configProtoCustomizer(
        shaftCalcBuildBits: shaftCalcBuildBits,
      ),
      protoPath: ProtoPath.root,
    );

    final shaftRight = ComposedConfigShaftRight(
      editingBits: messageEditingBits,
    );

    return ComposedConfigShaft.merge$(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      shaftCalcBuildBits: shaftCalcBuildBits,
      configShaftRight: shaftRight,
      shaftContentBits: MessageContent.create(
        messageEditingBits: messageEditingBits,
      ),
    );
  }
}
