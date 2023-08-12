import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

part 'map_entry_key.g.has.dart';
part 'map_entry_key.g.compose.dart';

@Has()
@Compose()
abstract class MapEntryKeyShaftRight {}

@Compose()
abstract class MapEntryKeyShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class MapEntryKeyShaft
    implements
        ShaftCalcBuildBits,
        MapEntryKeyShaftMerge,
        MapEntryKeyShaftRight,
        ShaftCalc {
  static MapEntryKeyShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {

    final shaftRight = ComposedMapEntryKeyShaftRight();
    final shaftMerge = ComposedMapEntryKeyShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        throw "todo";
      },
    );

    return ComposedMapEntryKeyShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      mapEntryKeyShaftMerge: shaftMerge,
      mapEntryKeyShaftRight: shaftRight,
    );
  }
}


// part of 'map.dart';
//
// @Compose()
// abstract class PfeShaftMapEntryKey
//     implements ShaftCalcBuildBits, EditingShaftContentBits, ShaftCalc {
//   static PfeShaftMapEntryKey of(ShaftCalcBuildBits shaftCalcBuildBits) {
//     final mapEntry = shaftCalcBuildBits.leftCalc as PfeMapShaftBits;
//
//     final mapKeyDataType = mapEntry.mapDataType.mapKeyDataType;
//     final contentBits = switch (mapKeyDataType) {
//       StringDataType() => PfeShaftString.of(
//           fv: mapEntry.pfeMapKeyFw as Fw<String?>,
//           stringDataType: mapKeyDataType,
//         ),
//       CoreIntDataType() => PfeShaftInt.of(
//           fv: mapEntry.pfeMapKeyFw as Fw<int?>,
//           coreIntDataType: mapKeyDataType,
//         ),
//       final other => throw other,
//     };
//
//     return ComposedPfeShaftMapEntryKey.merge$(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//       editingShaftContentBits: contentBits,
//     );
//   }
// }
