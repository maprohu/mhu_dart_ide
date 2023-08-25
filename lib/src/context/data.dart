import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/context/asset.dart';
import 'package:mhu_dart_ide/src/context/config.dart';
import 'package:mhu_dart_ide/src/context/control.dart';
export 'package:mhu_dart_ide/src/context/asset.dart';
import 'package:mhu_dart_ide/src/context/persist.dart';
import 'package:mhu_dart_ide/src/context/theme.dart';
export 'package:mhu_dart_ide/src/context/persist.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

import '../../proto.dart';
import '../model.dart';
import 'data.dart' as $lib;

part 'data.g.dart';

part 'data.g.has.dart';

@Has()
class DataObj with MixDataCtx, MixDisposers {
  late final MdiConfigMsg$Fw configFw;
  late final MdiWindowStateMsg$Fw windowStateFw;
  late final MdiThemeMsg$Fw themeFw;
  late final MdiShaftNotificationsMsg$Fw notificationsFw;
  late final MdiSequencesMsg$Fw sequencesFw;

  late final themeWrapFr = disposers.fr(
    () => dataCtx.createThemeWrap(
      themeMsg: themeFw(),
    ),
  );
  late final configWrapFr = disposers.fr(
    () => dataCtx.createConfigWrap(
      configMsg: configFw(),
    ),
  );
  late final controlWrapFr = disposers.fr(
    () => ControlWrap(),
  );
}

@Compose()
@Has()
abstract class DataCtx implements PersistCtx, AssetCtx, HasDataObj {}

Future<DataCtx> createConfigCtx({
  @Ext() required PersistCtx persistCtx,
  required AssetCtx assetCtx,
}) async {
  final PersistCtx(
    :persistObj,
  ) = persistCtx;
  final dataObj = DataObj()
    ..disposers = DspImpl()
    ..configFw = MdiConfigMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MdiConfigIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    )
    ..windowStateFw = MdiWindowStateMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MdiWindowStateIsarSingletonFwFactory>()
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

  return ComposedDataCtx.merge$(
    persistCtx: persistCtx,
    assetCtx: assetCtx,
    dataObj: dataObj,
  )..initMixDataCtx(dataObj);
}

WindowStateMsg watchWindowStateMsg({
  @extHas required DataObj dataObj,
}) {
  return dataObj.windowStateFw.watch();
}
