import 'package:mhu_dart_ide/src/shaft/build_runner.dart';
import 'package:mhu_dart_ide/src/shaft/config.dart';
import 'package:mhu_dart_ide/src/shaft/editing/edit_scalar.dart';
import 'package:mhu_dart_ide/src/shaft/main_menu.dart';
import 'package:mhu_dart_ide/src/shaft/not_implemented.dart';
import 'package:mhu_dart_ide/src/shaft/options.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map_entry_key.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map_entry_value.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import '../../proto.dart';
import '../screen/calc.dart';
import 'editing/editing.dart';
import 'editing/int.dart';
import 'error.dart';
import 'proto/field/map_entry.dart';
import 'proto/field/new_map_entry.dart';

typedef ShaftCalcBuilder = ShaftCalc Function(ShaftCalcBuildBits buildBits);

final _shaftPbi = lookupPbiMessage(MdiShaftMsg);

ShaftCalc calculateShaft(ShaftCalcChain shaftCalcChain) {
  final ShaftCalcChain(:shaftMsg) = shaftCalcChain;
  final type = shaftMsg.shaftIdentifier.type;

  final shaftCalcBuildBits = shaftCalcChain.toBuildBits(
    shaftType: type,
  );

  return switch (type) {
    MdiShaftIdentifierMsg_Type$mainMenu() => MainMenuShaft.create(shaftCalcBuildBits),
    MdiShaftIdentifierMsg_Type$options() => OptionsShaft.create(shaftCalcBuildBits),
    MdiShaftIdentifierMsg_Type$config() => ConfigShaft.create(shaftCalcBuildBits),
    MdiShaftIdentifierMsg_Type$concreteField() => ConcreteFieldShaft.create(shaftCalcBuildBits),
    MdiShaftIdentifierMsg_Type$mapEntry() => MapEntryShaft.create(shaftCalcBuildBits),
    MdiShaftIdentifierMsg_Type$newMapEntry() => NewMapEntryShaft.create(shaftCalcBuildBits),
    MdiShaftIdentifierMsg_Type$mapEntryKey() => MapEntryKeyShaft.create(shaftCalcBuildBits),
    MdiShaftIdentifierMsg_Type$mapEntryValue() => MapEntryValueShaft.create(shaftCalcBuildBits),
    MdiShaftIdentifierMsg_Type$editScalar() => EditScalarShaft.create(shaftCalcBuildBits),
    MdiShaftIdentifierMsg_Type$buildRunner() => BuildRunnerShaft.create(shaftCalcBuildBits),
    _ => NotImplementedShaft.create(shaftCalcBuildBits),
  };
}
