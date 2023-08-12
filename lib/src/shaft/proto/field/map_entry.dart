import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

part 'map_entry.g.has.dart';
part 'map_entry.g.compose.dart';

@Has()
@Compose()
abstract class MapEntryShaftRight {}

@Compose()
abstract class MapEntryShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class MapEntryShaft
    implements
        ShaftCalcBuildBits,
        MapEntryShaftMerge,
        MapEntryShaftRight,
        ShaftCalc {
  static MapEntryShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {

    final shaftRight = ComposedMapEntryShaftRight();
    final shaftMerge = ComposedMapEntryShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        throw "todo";
      },
    );

    return ComposedMapEntryShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      mapEntryShaftMerge: shaftMerge,
      mapEntryShaftRight: shaftRight,
    );
  }
}


// part of 'map.dart';
//
// @Has()
// typedef PfeMapKeyFw<K> = Fw<K>;
// @Has()
// typedef PfeMapValueFw<V> = Fw<V>;
//
// @Compose()
// abstract class PfeMapEntryBits implements HasPfeMapKeyFw, HasPfeMapValueFw {}
//
// abstract class PfeMapShaftBits implements PfeMapFieldBits, PfeMapEntryBits {}
//
// abstract class PfeShaftMapFieldEntry implements PfeMapShaftBits, ShaftCalc {
//   static PfeShaftMapFieldEntry create(ShaftCalcBuildBits shaftCalcBuildBits) {
//     final pfeShaftMapField = shaftCalcBuildBits.shaftCalcChain.leftSignificantCalc
//     as PfeShaftMapField;
//
//     pfeShaftMapField.mapKeyValueGeneric(<K, V>(pfeShaftMapField) {
//       final mapFu = pfeShaftMapField.pfeMapFieldFu;
//
//       final keyAttribute = pfeShaftMapField.mapDataType.mapKeyDataType
//           .mapEntryKeyMsgAttribute;
//
//       final key = keyAttribute.readAttribute(
//         shaftCalcBuildBits.shaftMsg.mapEntry.mapEntryKey,);
//
//       final valueFw = mapFu.itemFwNullable(key);
//
//
//       final mapValueDataType = pfeShaftMapField.mapDataType.mapValueDataType;
//
//
//
//       return ComposedPfeShaftMapEntryValue.merge$(
//         shaftCalcBuildBits: shaftCalcBuildBits,
//         shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//         editingShaftContentBits: contentBits,
//         editScalarShaftBits: contentBits,
//       );
//     });
//   }
// }
