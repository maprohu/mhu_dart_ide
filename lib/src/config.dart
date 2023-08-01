// ignore_for_file: unused_import

import 'package:isar/isar.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/theme.dart';

import '../proto.dart';
import 'state.dart';

part 'config.freezed.dart';

@freezedStruct
class MdiConfigBits with _$MdiConfigBits {
  MdiConfigBits._();
  factory MdiConfigBits({
    required MdiConfigMsg$Fw config,
    required MdiStateMsg$Fw state,
    required MdiThemeMsg$Fw theme,
    required DspReg disposers,
  }) = _MdiConfigBits;

  static Future<MdiConfigBits> create({
    required Isar isar,
    required DspReg disposers,
  }) async {
    final configFw = await isar.singletonFwProto(
      id: MdiSingleton.config.index,
      create: MdiConfigMsg.create,
      disposers: disposers,
    );
    final stateFw = await isar.singletonFwProto(
      id: MdiSingleton.state.index,
      create: MdiStateMsg.create,
      disposers: disposers,
      defaultValue: mdiDefaultState,
    );
    final themeFw = await isar.singletonFwProto(
      id: MdiSingleton.theme.index,
      create: MdiThemeMsg.create,
      disposers: disposers,
      defaultValue: mdiDefaultTheme,
    );

    return MdiConfigBits(
      theme: MdiThemeMsg$Fw(
        themeFw,
        disposers: disposers,
      ),
      state: MdiStateMsg$Fw(
        stateFw,
        disposers: disposers,
      ),
      config: MdiConfigMsg$Fw(
        configFw,
        disposers: disposers,
      ),
      disposers: disposers,
    );
  }

  late final stateCalc = disposers.fr(() => StateCalc(state()));
  late final themeCalc = disposers.fr(() => ThemeCalc(theme()));
  late final configCalc = disposers.fr(() => ConfigCalc(config()));
}

mixin HasConfigBits {
  MdiConfigBits get configBits;

  late final config = configBits.config;
  late final state = configBits.state;
  late final theme = configBits.theme;

  late final stateCalc = configBits.stateCalc;
  late final themeCalc = configBits.themeCalc;

}
class ConfigCalc {
  final MdiConfigMsg config;

  ConfigCalc(this.config);
}
