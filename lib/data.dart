part of 'main.dart';

@collection
final class MdiSingletonRecord extends SingletonRecord {}

final mdiIsarSingletonWatchFactories =
    createIsarSingletonWatchFactories<Msg, MdiSingletonRecord>({
  1: MdiConfigIsarSingletonWatchFactory.instance,
});

typedef MdiIsarSingletonWatchFactory<M extends Object>
    = IsarSingletonWatchFactory<M, MdiSingletonRecord>;

MdiIsarSingletonWatchFactory<M> mdiIsarSingletonWatchFactory<M extends Msg>({
  @ext required CreateValue<M> createValue,
  DefaultValue? defaultValue,
}) {
  return createIsarSingletonProtoWriteOnlyWatchFactory(
    createValue: createValue,
    createRecord: MdiSingletonRecord.new,
    defaultValue: defaultValue,
  );
}

Future<WatchMessage<M>> mdiProducePersistObjSingletonWatch<M extends Msg>({
  @ext required MdiIsarSingletonWatchFactory<M> isarSingletonWatchFactory,
  required PersistObj persistObj,
}) {
  return isarSingletonWatchFactory.produceIsarSingletonWatch(
    isarSingletonCollection: persistObj.isar.mdiSingletonRecords,
    disposers: persistObj.flushDisposers,
  );
}
