import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

part 'proto_customizer.g.dart';

part 'proto_customizer.g.has.dart';
// part 'proto_customizer.g.compose.dart';

const keyParamName = "K";
const keyParam = TypeParam(keyParamName);
const valueParam = TypeParam("V");

@Customizers([
  Customizer(
    name: "mapEntryFeature",
    typeParams: [keyParam, valueParam],
    key: TypeWithArgs<MapFieldAccess>(typeArgs: [
      TypeWithArgs<Msg>(),
      keyParam,
      valueParam,
    ]),
    input: TypeWithArgs<MapEntry>(typeArgs: [
      keyParam,
      valueParam,
    ]),
  ),
  Customizer(
    name: "mapKeyFeature",
    typeParams: [keyParam, valueParam],
    key: TypeWithArgs<MapFieldAccess>(typeArgs: [
      TypeWithArgs<Msg>(),
      keyParam,
      valueParam,
    ]),
    input: TypeWithArgs<MapEntry>(typeArgs: [
      keyParam,
      valueParam,
    ]),
    outputParams: [],
    output: TypeParam(
      keyParamName,
      nullable: true,
    ),
  ),
])
@Has()
class ProtoCustomizer {
  late final mapEntryLabel = MapEntryFeature<String>(
    <K, V>(mapFieldAccess, mapEntry) => mapEntry.key.toString(),
  );

  late final mapDefaultKey = MapKeyFeature(
    <K, V>(mapFieldAccess, mapEntry) => null,
  );
}

void _setup(ProtoCustomizer cst) {
  cst.mapEntryLabel.put(
    MdiConfigMsg$.dartPackages,
    (MapEntry<int, MdiDartPackageMsg> input) => input.value.path,
  );
}

void _use(ProtoCustomizer cst) {
  final mapEntry = MapEntry(
    1,
    MdiDartPackageMsg()
      ..path = "some/path"
      ..freeze(),
  );
  String label = cst.mapEntryLabel(
    MdiConfigMsg$.dartPackages,
    mapEntry,
  );
}
