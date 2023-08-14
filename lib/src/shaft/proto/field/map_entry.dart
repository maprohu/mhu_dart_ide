import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/model.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/proto/content/value_browsing.dart';

part 'map_entry.g.has.dart';

part 'map_entry.g.compose.dart';

@Has()
@Compose()
abstract class MapEntryShaftRight implements HasEditingBits {}

@Compose()
abstract class MapEntryShaft
    implements
        ShaftCalcBuildBits,
        ShaftContentBits,
        MapEntryShaftRight,
        ShaftCalc {
  static MapEntryShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final left = shaftCalcBuildBits.leftCalc as HasEditingBits;
    final mapEditingBits = left.editingBits as MapEditingBits;

    return mapEditingBits.mapEditingBitsGeneric(
      <K, V>(mapEditingBits) {
        final key = mapEditingBits
            .mapDataType.mapKeyDataType.mapEntryKeyMsgAttribute
            .readAttribute(
          shaftCalcBuildBits.shaftMsg.shaftIdentifier.mapEntry,
        );

        final content = ValueBrowsingContent.scalar(
          scalarDataType: mapEditingBits.mapDataType.mapValueDataType,
          scalarValue: mapEditingBits.itemValue(key),
        );

        final shaftRight = ComposedMapEntryShaftRight(
          editingBits: content.editingBits,
        );

        return ComposedMapEntryShaft.merge$(
          shaftCalcBuildBits: shaftCalcBuildBits,
          shaftHeaderLabel: key.toString(),
          shaftContentBits: content,
          mapEntryShaftRight: shaftRight,
        );
      },
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
