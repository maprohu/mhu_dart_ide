import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_ide/proto.dart';
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
abstract class MdiConfigIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MdiConfigMsg> {
  static final instance =
      ComposedMdiConfigIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory:
        MdiConfigMsg.new.createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

@Compose()
abstract class MdiWindowStateIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MdiWindowStateMsg> {
  static final instance =
      ComposedMdiWindowStateIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory:
        MdiWindowStateMsg.new.createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

@Compose()
abstract class MdiThemeIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MdiThemeMsg> {
  static final instance =
      ComposedMdiThemeIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory:
        MdiThemeMsg.new.createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

@Compose()
abstract class MdiShaftNotificationsIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MdiShaftNotificationsMsg> {
  static final instance = ComposedMdiShaftNotificationsIsarSingletonFwFactory
      .isarSingletonFwFactory(
    isarSingletonFwFactory: MdiShaftNotificationsMsg.new
        .createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

@Compose()
abstract class MdiSequencesIsarSingletonFwFactory
    implements IsarSingletonFwFactory<MdiSequencesMsg> {
  static final instance =
      ComposedMdiSequencesIsarSingletonFwFactory.isarSingletonFwFactory(
    isarSingletonFwFactory:
        MdiSequencesMsg.new.createIsarSingletonProtoWriteOnlyFwFactory(),
  );
}

final isarSingletonFwFactories = createIsarSingletonFwFactories<Msg>({
  0: MdiConfigIsarSingletonFwFactory.instance,
  1: MdiWindowStateIsarSingletonFwFactory.instance,
  2: MdiThemeIsarSingletonFwFactory.instance,
  3: MdiShaftNotificationsIsarSingletonFwFactory.instance,
  4: MdiSequencesIsarSingletonFwFactory.instance,
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
