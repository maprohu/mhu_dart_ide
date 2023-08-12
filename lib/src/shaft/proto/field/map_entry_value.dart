import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

part 'map_entry_value.g.has.dart';
part 'map_entry_value.g.compose.dart';

@Has()
@Compose()
abstract class MapEntryValueShaftRight {}

@Compose()
abstract class MapEntryValueShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class MapEntryValueShaft
    implements
        ShaftCalcBuildBits,
        MapEntryValueShaftMerge,
        MapEntryValueShaftRight,
        ShaftCalc {
  static MapEntryValueShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {

    final shaftRight = ComposedMapEntryValueShaftRight();
    final shaftMerge = ComposedMapEntryValueShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        throw "todo";
      },
    );

    return ComposedMapEntryValueShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      mapEntryValueShaftMerge: shaftMerge,
      mapEntryValueShaftRight: shaftRight,
    );
  }
}


// part of 'map.dart';
//
// @Compose()
// abstract class PfeShaftMapEntryValue<T>
//     implements
//         ShaftCalcBuildBits,
//         EditingShaftContentBits<T>,
//         ShaftCalc,
//         HasEditScalarShaftBits<T> {
//   static PfeShaftMapEntryValue of(ShaftCalcBuildBits shaftCalcBuildBits) {
//     final mapEntry = shaftCalcBuildBits.leftCalc as PfeMapShaftBits;
//
//     final dataType = mapEntry.mapDataType.mapValueDataType;
//
//     final contentBits = editScalarShaftLabeledContentBits(
//       editScalarShaftBits: ComposedEditScalarShaftBits(
//         editingFw: mapEntry.pfeMapValueFw,
//         scalarDataType: dataType,
//       ),
//     );
//
//     return ComposedPfeShaftMapEntryValue.merge$(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//       editingShaftContentBits: contentBits,
//       editScalarShaftBits: contentBits,
//     );
//   }
// }
