part of 'main.dart';

@Has()
typedef MdiConfigWatch = WatchProto<MdiConfigMsg>;

@Compose()
abstract class MdiConfigObj
    implements HasSchemaLookupByName, HasMdiConfigWatch {}

Future<MdiConfigObj> createSampleConfigObj(AppCtx appCtx) async {
  final mdiConfigWatch = await mdiIsarSingletonWatchFactories
      .lookupSingletonByType<MdiConfigIsarSingletonWatchFactory>()
      .mdiProducePersistObjSingletonWatch(persistObj: appCtx.persistObj);

  return ComposedMdiConfigObj(
    schemaLookupByName: await mhuDartIdePbschema
        .pbschemaFileDescriptorSet()
        .descriptorSchemaLookupByName(
      dependencies: [],
    ),
    mdiConfigWatch: mdiConfigWatch,
  );
}

MdiConfigObj mdiConfigObj({
  @ext required ConfigCtx configCtx,
}) {
  return configCtx.configObj;
}

@Compose()
abstract class MdiConfigIsarSingletonWatchFactory
    implements MdiIsarSingletonWatchFactory<MdiConfigMsg> {
  static final instance =
      ComposedMdiConfigIsarSingletonWatchFactory.isarSingletonWatchFactory(
    isarSingletonWatchFactory: MdiConfigMsg.new.mdiIsarSingletonWatchFactory(),
  );
}
