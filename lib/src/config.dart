// ignore_for_file: unused_import

import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/theme.dart';

import '../proto.dart';
import 'state.dart';

part 'config.g.has.dart';

part 'config.g.compose.dart';

@Has()
typedef ConfigFw = MdiConfigMsg$Fw;
@Has()
typedef StateFw = MdiStateMsg$Fw;
@Has()
typedef ThemeFw = MdiThemeMsg$Fw;

@Has()
typedef StateCalcFr = Fr<StateCalc>;
@Has()
typedef ThemeCalcFr = Fr<ThemeCalc>;
@Has()
typedef ConfigCalcFr = Fr<ConfigCalc>;

@Compose()
abstract class ConfigBits
    implements
        HasConfigFw,
        HasStateFw,
        HasThemeFw,
        HasStateCalcFr,
        HasThemeCalcFr,
        HasConfigCalcFr,
        HasIsarDatabase,
        HasFwUpdateGroup {
  static Future<ConfigBits> create({
    required Isar isar,
    required DspReg disposers,
  }) async {
    final configFw = await isar.singletonFwProtoWriteOnly(
      id: MdiSingleton.config.index,
      create: MdiConfigMsg.create,
      disposers: disposers,
    );
    final stateFw = await isar.singletonFwProtoWriteOnly(
      id: MdiSingleton.state.index,
      create: MdiStateMsg.create,
      disposers: disposers,
      defaultValue: mdiDefaultState,
    );
    final themeFw = await isar.singletonFwProtoWriteOnly(
      id: MdiSingleton.theme.index,
      create: MdiThemeMsg.create,
      disposers: disposers,
      defaultValue: mdiDefaultTheme,
    );

    return ComposedConfigBits(
      themeFw: MdiThemeMsg$Fw(
        themeFw,
        disposers: disposers,
      ),
      stateFw: MdiStateMsg$Fw(
        stateFw,
        disposers: disposers,
      ),
      configFw: MdiConfigMsg$Fw(
        configFw,
        disposers: disposers,
      ),
      themeCalcFr: disposers.fr(() => ThemeCalc(themeFw())),
      stateCalcFr: disposers.fr(() => StateCalc(stateFw())),
      configCalcFr: disposers.fr(() => ConfigCalc(configFw())),
      isarDatabase: isar,
      fwUpdateGroup: FwUpdateGroup.global,
    );
  }
}

// mixin HasConfigBits {
//   MdiConfigBits get configBits;
//
//   late final config = configBits.config;
//   late final state = configBits.state;
//   late final theme = configBits.theme;
//
//   late final stateCalc = configBits.stateCalc;
//   late final themeCalc = configBits.themeCalc;
//
// }

class ConfigCalc {
  final MdiConfigMsg config;

  ConfigCalc(this.config);
}

extension HasStateFwX on HasStateFw {
  void clearFocusedShaft() {
    stateFw.rebuild((state) {
      state.clearFocusedShaft();
    });
  }
}
