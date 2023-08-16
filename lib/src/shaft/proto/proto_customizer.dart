import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

part 'proto_customizer.g.dart';

part 'proto_customizer.g.has.dart';

@Customizer()
typedef MapEntryFeature<O> = O Function<K, V>(
  MapFieldAccess<Msg, K, V> mapFieldAccess,
  MapEntry<K, V> mapEntry,
);

@Customizer()
typedef MapKeyFeature = K? Function<K, V>(
  MapFieldAccess<Msg, K, V> mapFieldAccess,
);

@Has()
class ProtoCustomizer {
  late final mapEntryLabel = MapEntryFeatureCustomizer<String>(
    <K, V>(mapFieldAccess, mapEntry) => mapEntry.key.toString(),
  );

  late final mapDefaultKey = MapKeyFeatureCustomizer(
    <K, V>(mapFieldAccess) => null,
  );
}

// void _setup(ProtoCustomizer cst) {
//   cst.mapEntryLabel.put(
//     MdiConfigMsg$.dartPackages,
//     (MapEntry<int, MdiDartPackageMsg> input) => input.value.path,
//   );
// }
//
// void _use(ProtoCustomizer cst) {
//   final mapEntry = MapEntry(
//     1,
//     MdiDartPackageMsg()
//       ..path = "some/path"
//       ..freeze(),
//   );
//   String label = cst.mapEntryLabel(
//     MdiConfigMsg$.dartPackages,
//     mapEntry,
//   );
// }
