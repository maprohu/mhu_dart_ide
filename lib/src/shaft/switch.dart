import 'package:mhu_dart_ide/src/generated/mhu_dart_ide.pbfield.dart';
import 'package:mhu_dart_ide/src/shaft/config.dart';
import 'package:mhu_dart_ide/src/shaft/main_menu.dart';
import 'package:mhu_dart_ide/src/shaft/options.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map.dart';

import '../screen/calc.dart';
import 'error.dart';


typedef ShaftCalcBuilder = ShaftCalc Function(ShaftCalcChain shaftCalcChain);

ShaftCalc calculateShaft(ShaftCalcChain shaftCalcChain) {
  final ShaftCalcChain(:shaftMsg) = shaftCalcChain;
  final type = shaftMsg.type;

  return switch (type) {
    MdiShaftMsg_Type$mainMenu() => mainMenuShaftCalc(shaftCalcChain),
    MdiShaftMsg_Type$config() => configShaftCalc(shaftCalcChain),
    MdiShaftMsg_Type$pfeConcreteField() => PfeShaftConcreteField.of(shaftCalcChain),
    MdiShaftMsg_Type$options() => optionsShaftCalc(shaftCalcChain),
    MdiShaftMsg_Type$newMapItem() => PfeShaftNewMapEntry.of(shaftCalcChain),
    MdiShaftMsg_Type$entryKey() => PfeShaftMapEntryKey.of(shaftCalcChain),
    MdiShaftMsg_Type$entryValue() => PfeShaftMapEntryValue.of(shaftCalcChain),
    _ => notImplementedShaftCalc(
        shaftCalcChain: shaftCalcChain,
        message: "no shaft: ${shaftMsg.whichType().name}",
        stackTrace: StackTrace.current,
      ),
  };
}
