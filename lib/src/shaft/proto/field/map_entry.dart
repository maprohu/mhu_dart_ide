import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/model.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/proto/content/value_browsing.dart';
import 'package:mhu_dart_ide/src/shaft/proto/proto_path.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

part 'map_entry.g.has.dart';

part 'map_entry.g.compose.dart';

@Has()
@Compose()
abstract class MapEntryShaftRight implements HasEditingBits {}

@Compose()
abstract class MapEntryShaft
    implements
        ShaftCalcBuildBits,
        ShaftContentBits,
        MapEntryShaftRight,
        ShaftCalc {
  static MapEntryShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final left = shaftCalcBuildBits.leftCalc as HasEditingBits;
    final mapEditingBits = left.editingBits as MapEditingBits;

    final MapEditingBits(
      :protoCustomizer,
    ) = mapEditingBits;

    return mapEditingBits.mapEditingBitsGeneric(
      <K, V>(mapEditingBits) {
        final key = mapEditingBits
            .mapDataType.mapKeyDataType.mapEntryKeyMsgAttribute
            .readAttribute(
          shaftCalcBuildBits.shaftMsg.shaftIdentifier.mapEntry,
        );

        final scalarValue = mapEditingBits.itemValue(key);

        final content = ValueBrowsingContent.scalar(
          scalarDataType: mapEditingBits.mapDataType.mapValueDataType,
          scalarValue: scalarValue,
          extraContent: (sizedBits) {
            return sizedBits.menu([
              MenuItem(
                label: "Delete Entry",
                callback: () {
                  sizedBits.txn(() {
                    sizedBits.closeShaft();
                    mapEditingBits.updateValue((map) {
                      map.remove(key);
                    });
                  });
                },
              ),
            ]);
          },
          protoCustomizer: mapEditingBits.protoCustomizer,
          protoPath: ProtoPathMapItem(
            parent: mapEditingBits.protoPathField,
            key: key,
          ),
        );

        final shaftRight = ComposedMapEntryShaftRight(
          editingBits: content.editingBits,
        );

        final mapFieldAccess = mapEditingBits.protoPathField.fieldAccess
            as MapFieldAccess<Msg, K, V>;

        return ComposedMapEntryShaft.merge$(
          shaftCalcBuildBits: shaftCalcBuildBits,
          shaftHeaderLabel: protoCustomizer.mapEntryLabel(
            mapFieldAccess,
            MapEntry(
              key,
              scalarValue.readValue() ??
                  mapEditingBits.mapDataType.mapValueDataType.defaultValue,
            ),
          ),
          shaftContentBits: content,
          mapEntryShaftRight: shaftRight,
        );
      },
    );
  }
}
