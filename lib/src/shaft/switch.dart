// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_shafts/src/dart/workspace_scan_packages.dart';
// import 'package:mhu_shafts/src/shaft/build_runner.dart';
// import 'package:mhu_shafts/src/shaft/config.dart';
// import 'package:mhu_shafts/src/shaft/confirm.dart';
// import 'package:mhu_shafts/src/shaft/editing/edit_scalar.dart';
// import 'package:mhu_shafts/src/shaft/main_menu.dart';
// import 'package:mhu_shafts/src/shaft/not_implemented.dart';
// import 'package:mhu_shafts/src/shaft/options.dart';
// import 'package:mhu_shafts/src/shaft/proto/concrete_field.dart';
// import 'package:mhu_dart_proto/mhu_dart_proto.dart';
//
// import '../../proto.dart';
// import '../screen/calc.dart';
// import 'error.dart';
// import 'proto/field/map_entry.dart';
// import 'proto/field/new_map_entry.dart';
// import 'view_task.dart';
//
// // part 'switch.g.has.dart';
// // part 'switch.g.compose.dart';
//
// typedef ShaftCalcBuilder = ShaftCalc Function(ShaftCalcBuildBits buildBits);
//
// final _shaftPbi = lookupPbiMessage(MshShaftMsg);
//
// ShaftCalc calculateShaft(ShaftCalcChain shaftCalcChain) {
//   final ShaftCalcChain(:shaftMsg) = shaftCalcChain;
//   final shaftFactoryKey = shaftMsg.shaftIdentifier.shaftFactoryKey;
//
//   final shaftCalcBuildBits = shaftCalcChain.toBuildBits(
//     shaftType: type,
//   );
//
//   return switch (type) {
//     MshShaftIdentifierMsg_Type$mainMenu() =>
//       MainMenuShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$options() =>
//       OptionsShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$config() =>
//       ConfigShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$concreteField() =>
//       ConcreteFieldShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$mapEntry() =>
//       MapEntryShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$newMapEntry() =>
//       NewMapEntryShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$editScalar() =>
//       EditScalarShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$buildRunner() =>
//       BuildRunnerShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$viewTask() =>
//       ViewTaskShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$confirm() =>
//       ConfirmShaft.create(shaftCalcBuildBits),
//     MshShaftIdentifierMsg_Type$dartWorkspaceScanPackages() =>
//       DartWorkspaceScanPackagesShaft.create(shaftCalcBuildBits),
//     _ => NotImplementedShaft.create(shaftCalcBuildBits),
//   };
// }
//

