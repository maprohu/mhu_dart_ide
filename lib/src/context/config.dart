import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/context/persist.dart';
export 'package:mhu_dart_ide/src/context/persist.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

import '../../proto.dart';
import 'config.dart' as $lib;

part 'config.g.dart';

part 'config.g.has.dart';

part 'config.g.compose.dart';

@Has()
class ConfigObj with MixDisposers {
  late final MdiConfigMsg$Fw configFw;
  late final MdiStateMsg$Fw stateFw;
  late final MdiThemeMsg$Fw themeFw;
  late final MdiShaftNotificationsMsg$Fw notificationsFw;
  late final MdiSequencesMsg$Fw sequencesFw;
}

@Compose()
abstract class ConfigCtx implements PersistCtx, HasConfigObj {}

Future<ConfigCtx> createConfigCtx({
  @Ext() required PersistCtx persistCtx,
}) async {
  final PersistCtx(
    :persistObj,
  ) = persistCtx;
  final configObj = ConfigObj()
    ..disposers = DspImpl()
    ..configFw = MdiConfigMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MdiConfigIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    )
    ..stateFw = MdiStateMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MdiStateIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    )
    ..themeFw = MdiThemeMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MdiThemeIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    )
    ..sequencesFw = MdiSequencesMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MdiSequencesIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    )
    ..notificationsFw = MdiShaftNotificationsMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MdiShaftNotificationsIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    );

  return ComposedConfigCtx.persistCtx(
    persistCtx: persistCtx,
    configObj: configObj,
  );
}

StateMsg watchStateMsg({
  @extHas required ConfigObj configObj,
}) {
  return configObj.stateFw.watch();
}
