import 'package:mhu_dart_ide/src/generated/mhu_dart_ide.pbfield.dart';
import 'package:mhu_dart_ide/src/shaft/config.dart';
import 'package:mhu_dart_ide/src/shaft/main_menu.dart';
import 'package:mhu_dart_ide/src/shaft/options.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map.dart';

import '../screen/calc.dart';
import 'error.dart';

ShaftCalc calculateShaft(ShaftCalcChain shaftCalcChain) {
  final ShaftCalcChain(:shaftMsg) = shaftCalcChain;
  final type = shaftMsg.type;

  return switch (type) {
    MdiShaftMsg_Type$mainMenu() => MainMenuShaftCalc(shaftCalcChain),
    MdiShaftMsg_Type$config() => ConfigShaftCalc(shaftCalcChain),
    MdiShaftMsg_Type$pfeConcreteField() => PfeConcreteFieldShaftCalc(shaftCalcChain),
    MdiShaftMsg_Type$options() => OptionsShaftCalc(shaftCalcChain),
    MdiShaftMsg_Type$newMapItem() => NewMapItemShaftCalc(shaftCalcChain),
    MdiShaftMsg_Type$entryKey() => EntryKeyShaftCalc(shaftCalcChain),
    MdiShaftMsg_Type$entryValue() => EntryValueShaftCalc(shaftCalcChain),
    _ => NotImplementedShaftCalc(
        shaftCalcChain,
        message: "no shaft: ${shaftMsg.whichType().name}",
        stackTrace: StackTrace.current,
      ),
  };

  /*
  return switch (shaftMsg.type) {
    MdiShaftMsg_Type$buildRunner(:final value) => mdiBuildRunnerMenuShaftBx(
        sizedBits: sizedBits,
        value: value,
      ),
    MdiShaftMsg_Type$config(:final value) => mdiConfigMenuShaftBx(
        sizedBits: sizedBits,
        value: value,
      ),
    MdiShaftMsg_Type$pfeConcreteField(:final value) =>
      mdiPfeConcreteFieldShaftBx(
        sizedBits: sizedBits,
        value: value,
      ),
    _ => errorShaftBx(
        sizedBits: sizedBits,
        message: "no shaft: ${shaftMsg.whichType().name}",
        stackTrace: StackTrace.current,
      )
  };

   */
}
