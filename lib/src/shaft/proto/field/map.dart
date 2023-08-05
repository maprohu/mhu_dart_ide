import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import '../../../../proto.dart';
import '../../../app.dart';
import '../../../bx/menu.dart';
import '../../../config.dart';
import '../../../op.dart';

part 'map.g.has.dart';

part 'map.g.compose.dart';


abstract class MapFieldBits implements HasMapFieldAccess {}

@Compose()
abstract class PfeShaftMapField
    implements
        ShaftCalc,
        PfeShaftConcreteFieldBits,
        PfeShaftConcreteField,
        MapFieldBits,
        HasPfeShaftMapFieldKey,
        HasPfeShaftMapFieldValue {
  static PfeShaftMapField of({
    required PfeShaftConcreteFieldBits pfeShaftConcreteFieldBits,
    required MapFieldAccess mapFieldAccess,
    required Mfw mfw,
  }) {
    final ffu = mapFieldAccess.fu(mfw);

    return ComposedPfeShaftMapField.pfeShaftConcreteFieldBits(
      pfeShaftConcreteFieldBits: pfeShaftConcreteFieldBits,
      mapFieldAccess: mapFieldAccess,
      pfeShaftMapFieldKey: ComposedPfeShaftMapFieldKey(),
      pfeShaftMapFieldValue: ComposedPfeShaftMapFieldValue(),
      buildShaftContent: (sizedBits) => sizedBits.fill(),
      buildShaftOptions: (shaftBits) {
        return [
          shaftBits.openerField(MdiShaftMsg$.newMapItem),
        ];
      },
    );
  }
}

@Has()
@Compose()
abstract class PfeShaftMapFieldKey {
  static PfeShaftMapFieldKey of({
    required MapFieldAccess mapFieldAccess,
  }) {
    return switch (mapFieldAccess.defaultMapKey) {
      PbIntMapKey() => ComposedPfeShaftMapFieldKey(),
      PbStringMapKey() => ComposedPfeShaftMapFieldKey(),
    };
  }
}

@Has()
@Compose()
abstract class PfeShaftMapFieldValue {}

abstract class PfeMapKeyBits implements HasDefaultPbMapKey {
  static PfeMapKeyBits of({
    required ShaftCalcChain shaftCalcChain,
  }) {
    final mapFieldKeyShaft = shaftCalcChain.leftCalc as PfeShaftMapFieldKey;
  }
}

abstract class PfeMapEntryBits implements PfeMapKeyBits, ShaftCalcBits {}

abstract class NewMapEntryBits implements MapFieldBits {}
@Compose()
abstract class PfeShaftNewMapEntry
    implements ShaftCalc, ShaftCalcBits, PfeMapEntryBits {
  static PfeShaftNewMapEntry of(ShaftCalcChain shaftCalcChain) {
    final mapFieldShaft =
        shaftCalcChain.leftSignificantCalc as HasMapFieldAccess;

    return ComposedPfeShaftNewMapEntry.shaftCalcBits(
      shaftCalcBits: shaftCalcChain,
      shaftCalcChain: shaftCalcChain,
      shaftHeaderLabel: "New Map Entry",
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

@Compose()
abstract class PfeShaftMapEntryKey
    implements ShaftCalc, ShaftCalcBits, ShaftContentBits {
  static PfeShaftMapEntryKey of(ShaftCalcChain shaftCalcChain) {
    final mapEntryCalc = shaftCalcChain.leftCalc as PfeShaftNewMapEntry;

    return ComposedPfeShaftMapEntryKey.shaftContentBits(
      shaftCalcBits: shaftCalcChain,
      shaftCalcChain: shaftCalcChain,
      shaftHeaderLabel: "Map Entry Key",
      buildShaftContent: (sizedBits) => sizedBits.fill(),
    );
  }
}

@Compose()
abstract class PfeShaftMapEntryValue implements ShaftCalc, ShaftCalcBuildBits {
  static PfeShaftMapEntryValue of(ShaftCalcChain shaftCalcChain) {
    return ComposedPfeShaftMapEntryValue.shaftCalcBuildBits(
      shaftCalcBuildBits: shaftCalcChain.toBuildBits,
      shaftHeaderLabel: "Map Entry Value",
      buildShaftContent: (sizedBits) => sizedBits.fill(),
    );
  }
}
