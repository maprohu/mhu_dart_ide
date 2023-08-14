import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/proto/content/message.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';
import 'package:mhu_dart_ide/src/sharing_box/browse_map.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

part 'value_browsing.g.compose.dart';

@Compose()
abstract class ValueBrowsingContent<T>
    implements ShaftContentBits, HasEditingBits<T> {
  static ValueBrowsingContent<T> concreteField<M extends GeneratedMessage, T>({
    required MessageUpdateBits<M> messageUpdateBits,
    required ScalarValue<M> messageValue,
    required FieldCoordinates fieldCoordinates,
    required DataType<T> dataType,
  }) {
    final DataType dt = dataType;
    switch (dt) {
      case ScalarDataType():
        dt as ScalarDataType<T>;
        return scalar(
          scalarDataType: dt,
          scalarValue: messageValue.scalarAttribute(
            messageUpdateBits: messageUpdateBits,
            scalarAttribute: dt.scalarAttribute(
              fieldCoordinates: fieldCoordinates,
            ),
          ),
        );
      case MapDataType():
        return dt.mapKeyValueGeneric<ValueBrowsingContent>(
          <K, V>(mapDataType) {
            return map(
              MapEditingBits.create(
                mapDataType: mapDataType,
                mapValue: messageValue.mapAttribute(
                  messageUpdateBits: messageUpdateBits,
                  hasReadAttribute: mapDataType.hasReadAttribute(
                    fieldCoordinates: fieldCoordinates,
                  ),
                ),
              ),
            );
          },
        ) as ValueBrowsingContent<T>;
      default:
        throw dataType;
    }
  }

  static ValueBrowsingContent<T> scalar<T>({
    required ScalarDataType<T> scalarDataType,
    required ScalarValue<T> scalarValue,
  }) {
    ValueBrowsingContent<T> build<V>(
      ScalarDataType<V> scalarDataType,
      ValueBrowsingContent<V> Function(
        ScalarEditingBits<V> scalarEditingBits,
      ) builder,
    ) {
      final scalarEditingBits = ScalarEditingBits.create(
        scalarDataType: scalarDataType,
        scalarValue: scalarValue as ScalarValue<V>,
      );

      final result = builder(scalarEditingBits) as ValueBrowsingContent<T>;

      return ComposedValueBrowsingContent(
        buildShaftContent: (sizedBits) {
          return [
            ...result.buildShaftContent(sizedBits),
            ...sizedBits.menu(items: [
              ShaftTypes.editScalar.opener(sizedBits),
            ]),
          ];
        },
        editingBits: result.editingBits,
      );
    }

    final ScalarDataType sdt = scalarDataType;
    switch (sdt) {
      case MessageDataType():
        return sdt.messageDataTypeGeneric<ValueBrowsingContent>(
          <M extends Msg>(messageDataType) {
            return message<M>(
              MessageEditingBits.create<M>(
                messageDataType: messageDataType,
                scalarValue: scalarValue as ScalarValue<M>,
              ),
            );
          },
        ) as ValueBrowsingContent<T>;
      case CoreIntDataType():
        return build(sdt, coreIntType);
      case StringDataType():
        return build(sdt, stringType);

      default:
        throw scalarDataType;
    }
  }

  static ValueBrowsingContent<int> coreIntType(
    ScalarEditingBits<int> scalarEditingBits,
  ) {
    return ComposedValueBrowsingContent(
      buildShaftContent: stringBuildShaftContent(
        scalarEditingBits.watchValue()?.toString(),
        nullLabel: "<null int>",
      ),
      editingBits: scalarEditingBits,
    );
  }

  static ValueBrowsingContent<String> stringType(
    ScalarEditingBits<String> scalarEditingBits,
  ) {
    return ComposedValueBrowsingContent(
      buildShaftContent: stringBuildShaftContent(
        scalarEditingBits.watchValue(),
      ),
      editingBits: scalarEditingBits,
    );
  }

  static ValueBrowsingContent<Map<K, V>> map<K, V>(
    MapEditingBits<K, V> mapEditingBits,
  ) {
    return ComposedValueBrowsingContent(
      buildShaftContent: (sizedBits) {
        return browseMapSharingBoxes(
          sizedShaftBuilderBits: sizedBits,
          mapEditingBits: mapEditingBits,
        );
      },
      buildShaftOptions: (shaftBuilderBits) {
        return [
          ShaftTypes.newMapEntry.opener(shaftBuilderBits),
        ];
      },
      editingBits: mapEditingBits,
    );
  }

  static ValueBrowsingContent<M> message<M extends Msg>(
    MessageEditingBits<M> messageEditingBits,
  ) {
    return ComposedValueBrowsingContent.shaftContentBits(
      shaftContentBits: MessageContent.create(
        messageEditingBits: messageEditingBits,
      ),
      editingBits: messageEditingBits,
    );
  }
}
