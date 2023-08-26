// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/proto.dart';
// import 'package:mhu_shafts/src/app.dart';
// import 'package:mhu_shafts/src/builder/sized.dart';
// import 'package:mhu_shafts/src/builder/text.dart';
// import 'package:mhu_shafts/src/bx/menu.dart';
// import 'package:mhu_shafts/src/bx/menu_dynamic.dart';
// import 'package:mhu_shafts/src/context/data.dart';
// import 'package:mhu_shafts/src/dart/dart_package.dart';
// import 'package:mhu_shafts/src/op.dart';
// import 'package:mhu_shafts/src/proto.dart';
// import 'package:mhu_shafts/src/screen/calc.dart';
// import 'package:mhu_shafts/src/shaft/proto/content/message.dart';
// import 'package:mhu_shafts/src/shaft/proto/proto_customizer.dart';
// import 'package:mhu_shafts/src/shaft/proto/proto_path.dart';
// import 'package:mhu_shafts/src/theme.dart';
// import 'package:mhu_dart_proto/mhu_dart_proto.dart';
//
// import '../long_running.dart';
//
// part 'config.g.has.dart';
//
// part 'config.g.compose.dart';
//
// part 'config_custromizer.dart';
//
// @Has()
// @Compose()
// abstract class ConfigShaftRight implements HasEditingBits<MshConfigMsg> {}
//
// @Compose()
// abstract class ConfigShaft
//     implements
//         ShaftCalcBuildBits,
//         ShaftContentBits,
//         ConfigShaftRight,
//         ShaftCalc {
//   static ConfigShaft create(
//     ShaftCalcBuildBits shaftCalcBuildBits,
//   ) {
//     final messageEditingBits = MessageEditingBits.create(
//       messageDataType:
//           shaftCalcBuildBits.configFw.read().pbi.calc.messageDataType,
//       scalarValue: shaftCalcBuildBits.configFw.toScalarValue,
//       protoCustomizer: configProtoCustomizer(
//         shaftCalcBuildBits: shaftCalcBuildBits,
//       ),
//       protoPath: ProtoPath.root,
//     );
//
//     final shaftRight = ComposedConfigShaftRight(
//       editingBits: messageEditingBits,
//     );
//
//     return ComposedConfigShaft.merge$(
//       shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       configShaftRight: shaftRight,
//       shaftContentBits: MessageContent.create(
//         messageEditingBits: messageEditingBits,
//       ),
//     );
//   }
// }
