part of 'map.dart';

@Compose()
abstract class PfeShaftMapEntryValue
    implements ShaftCalcBuildBits, EditingShaftContentBits, ShaftCalc {
  static PfeShaftMapEntryValue of(ShaftCalcBuildBits shaftCalcBuildBits) {
    final mapEntry = shaftCalcBuildBits.leftCalc as PfeMapEntryShaft;

    final dataType = mapEntry.mapDataType.mapValueDataType;

    final contentBits = switch (dataType) {
      MessageDataType() => MessageEditingShaftContentBits.of(
          mfw: mapEntry.pfeMapValueFw as Mfw,
          messageDataType: dataType,
        ),
      final other => throw other,
    };

    return ComposedPfeShaftMapEntryValue.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      editingShaftContentBits: contentBits,
    );
  }
}
