import 'package:mhu_dart_ide/src/shaft/config.dart';
import 'package:mhu_dart_ide/src/shaft/main_menu.dart';
import 'package:mhu_dart_ide/src/shaft/options.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import '../../proto.dart';
import '../screen/calc.dart';
import 'editing/int.dart';
import 'error.dart';

typedef ShaftCalcBuilder = ShaftCalc Function(ShaftCalcBuildBits buildBits);

final _shaftPbi = lookupPbiMessage(MdiShaftMsg);

ShaftCalc calculateShaft(ShaftCalcChain shaftCalcChain) {
  final ShaftCalcChain(:shaftMsg) = shaftCalcChain;
  final type = shaftMsg.type;

  final access = type.tagNumber$ == 0
      ? MdiShaftMsg$.error
      : _shaftPbi.calc.concreteFieldKeysByTagNumber[type.tagNumber$]!.calc
          .access as ScalarFieldAccess<MdiShaftMsg, dynamic>;

  final buildBits = shaftCalcChain.toBuildBits(
    shaftStateField: access,
  );

  return switch (type) {
    MdiShaftMsg_Type$mainMenu() => mainMenuShaftCalc(buildBits),
    MdiShaftMsg_Type$config() => configShaftCalc(buildBits),
    MdiShaftMsg_Type$pfeConcreteField() => PfeShaftConcreteField.of(buildBits),
    MdiShaftMsg_Type$options() => optionsShaftCalc(buildBits),
    MdiShaftMsg_Type$newMapEntry() => PfeShaftMapFieldNewEntry.of(buildBits),
    MdiShaftMsg_Type$mapEntryKey() => PfeShaftMapEntryKey.of(buildBits),
    MdiShaftMsg_Type$mapEntryValue() => PfeShaftMapEntryValue.of(buildBits),
    MdiShaftMsg_Type$editScalar() => editIntShaftCalc(buildBits),
    _ => notImplementedShaftCalc(
        shaftCalcBuildBits: buildBits,
        message: "no shaft: ${shaftMsg.whichType().name}",
        stackTrace: StackTrace.current,
      ),
  };
}
