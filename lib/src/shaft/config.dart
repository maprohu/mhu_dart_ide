import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/proto/content/message.dart';
import 'package:mhu_dart_ide/src/shaft/proto/proto_customizer.dart';
import 'package:mhu_dart_ide/src/shaft/proto/proto_path.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

part 'config.g.has.dart';

part 'config.g.compose.dart';

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
    final protoCustomizer = ProtoCustomizer();

    protoCustomizer.mapEntryLabel.put(
      MdiConfigMsg$.dartPackages,
      (mapEntry) => mapEntry.value.path.orIfBlank(
        () => "(${mapEntry.key})",
      ),
    );

    final messageEditingBits = MessageEditingBits.create(
      messageDataType:
          shaftCalcBuildBits.configFw.read().pbi.calc.messageDataType,
      scalarValue: shaftCalcBuildBits.configFw.toScalarValue,
      protoCustomizer: protoCustomizer,
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
