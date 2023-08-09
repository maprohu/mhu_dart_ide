part of 'map.dart';

@Compose()
abstract class PfeShaftMapEntryValue implements ShaftCalc, ShaftCalcBuildBits {
  static PfeShaftMapEntryValue of(ShaftCalcBuildBits shaftCalcBuildBits) {
    final mapEntry = shaftCalcBuildBits.leftCalc as PfeMapEntryShaft;

    return ComposedPfeShaftMapEntryValue.shaftCalcBuildBits(
      shaftCalcBuildBits: shaftCalcBuildBits,
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) => sizedBits.fillVerticalSharing(),
    );
  }
}
