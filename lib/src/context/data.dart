import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/asset.dart';
import 'package:mhu_shafts/src/context/config.dart';
import 'package:mhu_shafts/src/context/control.dart';
export 'package:mhu_shafts/src/context/asset.dart';
import 'package:mhu_shafts/src/context/persist.dart';
import 'package:mhu_shafts/src/context/theme.dart';
export 'package:mhu_shafts/src/context/persist.dart';
import 'package:mhu_shafts/src/screen/calc.dart';

import '../../proto.dart';
import '../model.dart';
import 'data.dart' as $lib;

part 'data.g.dart';

part 'data.g.has.dart';

part 'data.freezed.dart';

@Has()
class DataObj with MixDataCtx, MixDisposers {
  late final MshConfigMsg$Fw configFw;
  late final MshWindowStateMsg$Fw windowStateFw;
  late final MshThemeMsg$Fw themeFw;
  late final MshShaftNotificationsMsg$Fw notificationsFw;
  late final MshSequencesMsg$Fw sequencesFw;

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
    ..configFw = MshConfigMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MshConfigIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    )
    ..windowStateFw = MshWindowStateMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MshWindowStateIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    )
    ..themeFw = MshThemeMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MshThemeIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    )
    ..sequencesFw = MshSequencesMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MshSequencesIsarSingletonFwFactory>()
          .producePersistObjSingletonFw(persistObj: persistObj),
    )
    ..notificationsFw = MshShaftNotificationsMsg$Fw(
      await isarSingletonFwFactories
          .lookupSingletonByType<MshShaftNotificationsIsarSingletonFwFactory>()
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
