part of 'map.dart';

@Compose()
abstract class PfeShaftMapEntryKey
    implements ShaftCalcBuildBits, EditingShaftContentBits, ShaftCalc {
  static PfeShaftMapEntryKey of(ShaftCalcBuildBits shaftCalcBuildBits) {
    final mapEntry = shaftCalcBuildBits.leftCalc as PfeMapEntryShaft;

    final mapKeyDataType = mapEntry.mapDataType.mapKeyDataType;
    final contentBits = switch (mapKeyDataType) {
      StringDataType() => PfeShaftString.of(
          fv: mapEntry.pfeMapKeyFw as Fw<String?>,
          stringDataType: mapKeyDataType,
        ),
      CoreIntDataType() => PfeShaftInt.of(
          fv: mapEntry.pfeMapKeyFw as Fw<int?>,
          coreIntDataType: mapKeyDataType,
        ),
      final other => throw other,
    };

    return ComposedPfeShaftMapEntryKey.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      editingShaftContentBits: contentBits,
    );
  }
}
