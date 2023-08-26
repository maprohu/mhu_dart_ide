import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protobuf/protobuf.dart';

import 'persist.dart' as $lib;

part 'persist.g.dart';

part 'persist.g.has.dart';


@Has()
class PersistObj with MixIsar {
  final flushDisposers = DspImpl();
}

@Compose()
abstract class PersistCtx implements HasPersistObj {}

Future<PersistCtx> createPersistCtx({
  @Ext() required DspReg disposers,
}) async {
  final dir = await getApplicationSupportDirectory();

  logger.i("isar dir: $dir");
  final isar = await Isar.open(
    [
      SingletonRecordSchema,
    ],
    directory: dir.path,
  );
  final persistObj = PersistObj()..isar = isar;

  disposers.add(() async {
    await persistObj.flushDisposers.dispose();
    await isar.dispose();
  });

  return ComposedPersistCtx(
    persistObj: persistObj,
  );
}

@Compose()
abstract class MshConfigIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MshConfigMsg> {
  static final instance =
      ComposedMshConfigIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory:
        MshConfigMsg.new.createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

@Compose()
abstract class MshWindowStateIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MshWindowStateMsg> {
  static final instance =
      ComposedMshWindowStateIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory:
        MshWindowStateMsg.new.createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

@Compose()
abstract class MshThemeIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MshThemeMsg> {
  static final instance =
      ComposedMshThemeIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory:
        MshThemeMsg.new.createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

@Compose()
abstract class MshShaftNotificationsIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MshShaftNotificationsMsg> {
  static final instance = ComposedMshShaftNotificationsIsarSingletonFwFactory
      .isarSingletonFwFactory(
    isarSingletonFwFactory: MshShaftNotificationsMsg.new
        .createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

@Compose()
abstract class MshSequencesIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MshSequencesMsg> {
  static final instance =
      ComposedMshSequencesIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory:
        MshSequencesMsg.new.createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

final isarSingletonFwFactories = createIsarSingletonFwFactories<Msg>({
  0: MshConfigIsarSingletonFwFactory.instance,
  1: MshWindowStateIsarSingletonFwFactory.instance,
  2: MshThemeIsarSingletonFwFactory.instance,
  3: MshShaftNotificationsIsarSingletonFwFactory.instance,
  4: MshSequencesIsarSingletonFwFactory.instance,
});

class PersistObjSingletonFactoryMarker<M extends Msg,
    F extends IsarSingletonFwFactory<M>> {
  late final F factory;
}

// PersistObjSingletonFactoryMarker<M, F> markPersistObjSingletonFactory<M extends Msg, F extends IsarSingletonFwFactory<M>>({
//
//
// })

// Future<Fw<M>> createPersistObjSingletonFw<M extends Msg,
//     F extends IsarSingletonFwFactory<M>>({
//   required PersistObj persistObj,
// }) {
//   return isarSingletonFwFactories
//       .lookupSingletonByType<F>()
//       .produceIsarSingletonFw(
//         isar: persistObj.isar,
//         disposers: persistObj.flushDisposers,
//       );
// }

Future<Fw<M>> producePersistObjSingletonFw<M extends Msg>({
  @Ext() required IsarSingletonFwFactory<M> isarSingletonFwFactory,
  required PersistObj persistObj,
}) {
  return isarSingletonFwFactory.produceIsarSingletonFw(
    isar: persistObj.isar,
    disposers: persistObj.flushDisposers,
  );
}
