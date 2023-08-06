part of 'map.dart';

@Compose()
abstract class PfeShaftMapEntryValue implements ShaftCalc, ShaftCalcBuildBits {
  static PfeShaftMapEntryValue of(ShaftCalcBuildBits shaftCalcBuildBits) {
    return ComposedPfeShaftMapEntryValue.shaftCalcBuildBits(
      shaftCalcBuildBits: shaftCalcBuildBits,
      shaftHeaderLabel: "Map Entry Value",
      buildShaftContent: (sizedBits) => sizedBits.fill(),
    );
  }
}
