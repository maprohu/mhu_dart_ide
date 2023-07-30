import 'package:isar/isar.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_ide/src/isar.dart';

import '../proto.dart';

part 'config.freezed.dart';

@freezed
class MdiConfigBits with _$MdiConfigBits {
  const factory MdiConfigBits({
    required MdiConfigMsg$Fw config,
    required MdiStateMsg$Fw state,
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
    );

    return MdiConfigBits(
      state: MdiStateMsg$Fw(
        stateFw,
        disposers: disposers,
      ),
      config: MdiConfigMsg$Fw(
        configFw,
        disposers: disposers,
      ),
    );
  }
}

mixin HasConfigBits {
  MdiConfigBits get configBits;

  late final config = configBits.config;
  late final state = configBits.state;
}
