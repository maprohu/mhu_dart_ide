part of 'map.dart';

@Compose()
abstract class PfeMapFieldEntryNewBits implements PfeMapEntryBits {}

@Compose()
abstract class PfeShaftMapFieldNewEntry
    implements
        ShaftCalcBuildBits,
        PfeMapFieldBits,
        PfeMapEntryBits,
        PfeMapEntryShaft {
  static ShaftCalc of(ShaftCalcBuildBits shaftCalcBuildBits) {
    final mapFieldShaft = shaftCalcBuildBits.shaftCalcChain.leftSignificantCalc
        as PfeShaftMapField;

    final shaftMsgFu = shaftCalcBuildBits.shaftCalcChain.shaftMsgFu;

    late final stringKeyFw = Fw.fromFr(
      fr: shaftMsgFu.map((t) => t.newMapItem.mapEntry.stringKeyOpt),
      set: (value) {
        shaftMsgFu.update((shaft) {
          shaft.newMapItem.ensureMapEntry().stringKeyOpt = value;
        });
      },
    );
    late final intKeyFw = Fw.fromFr(
      fr: shaftMsgFu.map((t) => t.newMapItem.mapEntry.intKeyOpt),
      set: (value) {
        shaftMsgFu.update((shaft) {
          shaft.newMapItem.ensureMapEntry().intKeyOpt = value;
        });
      },
    );

    final keyFw = switch (mapFieldShaft.defaultPbMapKey) {
      PbStringMapKey() => stringKeyFw,
      PbIntMapKey() => intKeyFw,
    };

    final entryBits = ComposedPfeMapFieldEntryNewBits(
      pfeMapKeyFw: keyFw,
      pfeMapValueFw: fw(0), // TODO
    );

    return ComposedPfeShaftMapFieldNewEntry.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      pfeMapFieldBits: mapFieldShaft,
      pfeMapEntryBits: entryBits,
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        return sizedBits.menu(items: [
          sizedBits.openerField(MdiShaftMsg$.entryKey),
          sizedBits.openerField(MdiShaftMsg$.entryValue),
          MenuItem(
            label: "Save Entry",
            callback: () {},
          ),
        ]);
      },
    );
  }
}
