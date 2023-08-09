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
      fr: shaftMsgFu
          .map((t) => t.newMapEntry.mapEntry.mapEntryKey.stringKeyOpt),
      set: (value) {
        shaftMsgFu.update((shaft) {
          shaft.newMapEntry.ensureMapEntry().ensureMapEntryKey().stringKeyOpt =
              value;
        });
      },
    );
    late final intKeyFw = Fw.fromFr(
      fr: shaftMsgFu.map((t) => t.newMapEntry.mapEntry.mapEntryKey.intKeyOpt),
      set: (value) {
        shaftMsgFu.update((shaft) {
          shaft.newMapEntry.ensureMapEntry().ensureMapEntryKey().intKeyOpt =
              value;
        });
      },
    );

    final keyFw = switch (mapFieldShaft.mapDataType.mapKeyDataType) {
      StringDataType() => stringKeyFw,
      CoreIntDataType() => intKeyFw,
      final other => throw other,
    };

    final mapValueDataType = mapFieldShaft.mapDataType.mapValueDataType;

    final valueFw = mapValueDataType.dataTypeGeneric<Fw>(
      <V>() => fw<V>(mapValueDataType.defaultValue),
    );

    final entryBits = ComposedPfeMapFieldEntryNewBits(
      pfeMapKeyFw: keyFw,
      pfeMapValueFw: valueFw,
    );

    return ComposedPfeShaftMapFieldNewEntry.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      pfeMapFieldBits: mapFieldShaft,
      pfeMapEntryBits: entryBits,
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        return sizedBits.menu(items: [
          sizedBits.openerField(MdiShaftMsg$.mapEntryKey),
          sizedBits.openerField(MdiShaftMsg$.mapEntryValue),
          MenuItem(
            label: "Add Entry",
            callback: () {
              final keyValue = keyFw.read();
              final mapFu = mapFieldShaft.pfeMapFieldFu;
              final valueValue = valueFw.read();
              final messages = [
                if (keyValue == null) "Key is null.",
                if (mapFu.read().containsKey(keyValue)) "Key already exists.",
              ];
              if (messages.isNotEmpty) {
                sizedBits.showNotifications(messages);
              } else {
                shaftCalcBuildBits.fwUpdateGroup.run(() {
                  mapFu.update((items) {
                    items[keyValue] = valueValue;
                    // sizedBits.closeShaft();
                  });
                });
              }
            },
          ),
        ]);
      },
    );
  }
}
