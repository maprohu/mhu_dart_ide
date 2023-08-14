import 'package:collection/collection.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/model.dart';
import 'package:mhu_dart_ide/src/proto.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map.dart';

import '../screen/calc.dart';
import '../sharing_box.dart';

SharingBoxes browseMapSharingBoxes<K, V>({
  required SizedShaftBuilderBits sizedShaftBuilderBits,
  required MapEditingBits<K, V> mapEditingBits,
}) {
  final MapEditingBits(
    :mapDataType,
  ) = mapEditingBits;
  final value = mapEditingBits.watchValue();

  if (value == null) {
    return sizedShaftBuilderBits.itemText
        .left("<missing item>")
        .shaftContentSharing
        .toSingleElementIterable;
  }

  if (value.isEmpty) {
    return sizedShaftBuilderBits.itemText
        .left("<empty map>")
        .shaftContentSharing
        .toSingleElementIterable;
  }

  final sorted = value.entries.sortedByCompare(
    (e) => e.key,
    mapDataType.mapKeyDataType.mapKeyComparator,
  );

  final keyAttribute = mapDataType.mapKeyDataType.mapEntryKeyMsgAttribute;

  return sizedShaftBuilderBits.menu(
    sorted.map(
      (entry) {
        final shaftIdentifier = ShaftIdentifier()
          ..ensureMapEntry().let(
            (key) => keyAttribute.writeAttribute(key, entry.key),
          )
          ..freeze();
        return sizedShaftBuilderBits.opener(
          shaftIdentifier,
        );
      },
    ).toList(),
  );
}
