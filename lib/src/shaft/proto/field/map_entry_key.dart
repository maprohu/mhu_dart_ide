part of 'map.dart';

@Compose()
abstract class PfeShaftMapEntryKey
    implements ShaftCalcBuildBits, EditingShaftContentBits, ShaftCalc {
  static PfeShaftMapEntryKey of(ShaftCalcBuildBits shaftCalcBuildBits) {
    final mapEntry = shaftCalcBuildBits.leftCalc as PfeMapEntryShaft;

    final contentBits = switch (mapEntry.mapDataType.mapKeyDataType) {
      StringDataType() => PfeShaftString.of(
          fv: mapEntry.pfeMapKeyFw as Fw<String?>,
        ),
      CoreIntDataType() => PfeShaftInt.of(
          fv: mapEntry.pfeMapKeyFw as Fw<int?>,
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
