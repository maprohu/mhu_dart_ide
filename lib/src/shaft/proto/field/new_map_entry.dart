import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

part 'new_map_entry.g.has.dart';
part 'new_map_entry.g.compose.dart';

@Has()
@Compose()
abstract class NewMapEntryShaftRight {}

@Compose()
abstract class NewMapEntryShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class NewMapEntryShaft
    implements
        ShaftCalcBuildBits,
        NewMapEntryShaftMerge,
        NewMapEntryShaftRight,
        ShaftCalc {
  static NewMapEntryShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {

    final shaftRight = ComposedNewMapEntryShaftRight();
    final shaftMerge = ComposedNewMapEntryShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        throw "todo";
      },
    );

    return ComposedNewMapEntryShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      newMapEntryShaftMerge: shaftMerge,
      newMapEntryShaftRight: shaftRight,
    );
  }
}


// part of 'map.dart';
//
// @Compose()
// abstract class PfeMapFieldEntryNewBits implements PfeMapEntryBits {}
//
// @Compose()
// abstract class PfeShaftMapFieldNewEntry
//     implements
//         ShaftCalcBuildBits,
//         PfeMapFieldBits,
//         PfeMapEntryBits,
//         PfeMapShaftBits,
//         ShaftCalc {
//   static ShaftCalc of(ShaftCalcBuildBits shaftCalcBuildBits) {
//     final mapFieldShaft = shaftCalcBuildBits.shaftCalcChain.leftSignificantCalc
//         as PfeShaftMapField;
//
//     final shaftMsgFu = shaftCalcBuildBits.shaftCalcChain.shaftMsgFu;
//
//     late final stringKeyFw = Fw.fromFr(
//       fr: shaftMsgFu
//           .map((t) => t.newMapEntry.mapEntry.mapEntryKey.stringKeyOpt),
//       set: (value) {
//         shaftMsgFu.update((shaft) {
//           shaft.newMapEntry.ensureMapEntry().ensureMapEntryKey().stringKeyOpt =
//               value;
//         });
//       },
//     );
//     late final intKeyFw = Fw.fromFr(
//       fr: shaftMsgFu.map((t) => t.newMapEntry.mapEntry.mapEntryKey.intKeyOpt),
//       set: (value) {
//         shaftMsgFu.update((shaft) {
//           shaft.newMapEntry.ensureMapEntry().ensureMapEntryKey().intKeyOpt =
//               value;
//         });
//       },
//     );
//
//     final keyFw = switch (mapFieldShaft.mapDataType.mapKeyDataType) {
//       StringDataType() => stringKeyFw,
//       CoreIntDataType() => intKeyFw,
//       final other => throw other,
//     };
//
//     final mapValueDataType = mapFieldShaft.mapDataType.mapValueDataType;
//
//     Fw<M?> messageValueFw<M>(
//       MessageDataType messageDataType,
//     ) {
//       return Fw.fromFr(
//         fr: shaftMsgFu.map((t) {
//           final bytes = t.newMapEntry.mapEntry.bytesValueOpt;
//           if (bytes != null) {
//             return messageDataType.pbiMessage.instance.rebuild((m) {
//               m.mergeFromBuffer(bytes);
//             }) as M;
//           } else {
//             return null;
//           }
//         }),
//         set: (value) {
//           shaftMsgFu.update((shaft) {
//             if (value == null) {
//               shaft.ensureNewMapEntry().ensureMapEntry().clearBytesValue();
//             } else {
//               value as GeneratedMessage;
//               shaft.ensureNewMapEntry().ensureMapEntry().bytesValue =
//                   value.writeToBuffer();
//             }
//           });
//         },
//       );
//     }
//
//     final valueFw = mapValueDataType.dataTypeGeneric<Fw>(
//       <V>() {
//         return switch (mapValueDataType) {
//           MessageDataType() => messageValueFw<V>(mapValueDataType),
//           final other => throw other,
//         };
//       },
//     );
//
//     final entryBits = ComposedPfeMapFieldEntryNewBits(
//       pfeMapKeyFw: keyFw,
//       pfeMapValueFw: valueFw,
//     );
//
//     return ComposedPfeShaftMapFieldNewEntry.merge$(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       pfeMapFieldBits: mapFieldShaft,
//       pfeMapEntryBits: entryBits,
//       shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//       buildShaftContent: (sizedBits) {
//         return sizedBits.menu(items: [
//           sizedBits.openerField(MdiShaftMsg$.mapEntryKey),
//           sizedBits.openerField(MdiShaftMsg$.mapEntryValue),
//           MenuItem(
//             label: "Add Entry",
//             callback: () {
//               final keyValue = keyFw.read();
//               final mapFu = mapFieldShaft.pfeMapFieldFu;
//               final valueValue = valueFw.read();
//               final messages = [
//                 if (keyValue == null) "Key is null.",
//                 if (mapFu.read().containsKey(keyValue)) "Key already exists.",
//               ];
//               if (messages.isNotEmpty) {
//                 sizedBits.showNotifications(messages);
//               } else {
//                 shaftCalcBuildBits.fwUpdateGroup.run(() {
//                   mapFu.update((items) {
//                     items[keyValue] = valueValue;
//                     // sizedBits.closeShaft();
//                   });
//                 });
//               }
//             },
//           ),
//         ]);
//       },
//     );
//   }
// }
