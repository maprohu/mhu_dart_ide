part of 'map.dart';

@Compose()
abstract class PfeShaftMapEntryKey
    implements ShaftCalcBuildBits, ShaftContentBits, ShaftCalc {
  static PfeShaftMapEntryKey of(ShaftCalcBuildBits shaftCalcBuildBits) {
    final mapEntry = shaftCalcBuildBits.leftCalc as PfeMapEntryShaft;

    final contentBits = switch (mapEntry.defaultPbMapKey) {
      PbStringMapKey() => PfeShaftString.of(
          fv: mapEntry.pfeMapKeyFw as Fw<String>,
        ),
      PbIntMapKey() => PfeShaftInt.of(
          fv: mapEntry.pfeMapKeyFw as Fw<int>,
        ),
    };

    return ComposedPfeShaftMapEntryKey.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      shaftHeaderLabel: "Map Entry Key",
      shaftContentBits: contentBits,
    );
  }
}
