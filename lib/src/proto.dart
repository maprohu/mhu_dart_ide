import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

part 'proto.g.has.dart';

part 'proto.g.compose.dart';

// @Has()
// typedef EditingFr<T> = Fr<T>;
//
// @Has()
// typedef EditingFw<T> = Fw<T>;
//
// @Has()
// typedef EditingFu<T> = Fu<T>;

@Compose()
@Has()
abstract class EditingBits<T> implements ReadWatchValue<T?>, HasDataType<T> {}

@Compose()
@Has()
abstract class ScalarEditingBits<T>
    implements ScalarValue<T>, HasScalarDataType<T>, EditingBits<T> {
  static ScalarEditingBits<T> create<T>({
    required ScalarDataType<T> scalarDataType,
    required ScalarValue<T> scalarValue,
  }) {
    return ComposedScalarEditingBits.scalarValue(
      scalarValue: scalarValue,
      scalarDataType: scalarDataType,
      dataType: scalarDataType,
    );
  }
}

extension ScalarEditingBitsX<T> on ScalarEditingBits<T> {
  R scalarEditingBitsGeneric<R>(
    R Function<T>(
      ScalarEditingBits<T> scalarEditingBits,
    ) fn,
  ) {
    return scalarDataType.scalarDataTypeGeneric(
      <TT>(scalarDataType) {
        return fn(
          this as ScalarEditingBits<TT>,
        );
      },
    );
  }
}

// @Compose()
// abstract class UpdatingBits<T> implements EditingBits<T>, HasEditingFu<T> {
//   static UpdatingBits<T> create<T>({
//     required EditingFu<T> editingFu,
//     required DataType<T> dataType,
//   }) {
//     return ComposedUpdatingBits.editingBits(
//       editingBits: ComposedEditingBits(
//         dataType: dataType,
//         editingFr: editingFu,
//       ),
//       editingFu: editingFu,
//     );
//   }
// }

@Compose()
abstract class MapEditingBits<K, V>
    implements MapValue<K, V>, HasMapDataType<K, V>, EditingBits<Map<K, V>> {
  static MapEditingBits<K, V> create<K, V>({
    required MapDataType<K, V> mapDataType,
    required MapValue<K, V> mapValue,
  }) {
    return ComposedMapEditingBits.editingBits(
      editingBits: ComposedEditingBits.readWatchValue(
        readWatchValue: mapValue,
        dataType: mapDataType,
      ),
      mapDataType: mapDataType,
      updateValue: mapValue.updateValue,
    );
  }
}

extension MapEditingBitsX<K, V> on MapEditingBits<K, V> {
  R mapEditingBitsGeneric<R>(
    R Function<KK, VV>(
      MapEditingBits<KK, VV> mapEditingBits,
    ) fn,
  ) {
    return mapDataType.mapKeyValueGeneric(
      <KK, VV>(mapDataType) {
        return fn(
          this as MapEditingBits<KK, VV>,
        );
      },
    );
  }
}

@Compose()
@Has()
abstract class MessageEditingBits<M extends GeneratedMessage>
    implements ScalarEditingBits<M>, HasMessageDataType<M> {
  static MessageEditingBits<M> create<M extends GeneratedMessage>({
    required MessageDataType<M> messageDataType,
    required ScalarValue<M> scalarValue,
  }) {
    return ComposedMessageEditingBits.scalarEditingBits(
      scalarEditingBits: ScalarEditingBits.create(
        scalarDataType: messageDataType,
        scalarValue: scalarValue,
      ),
      messageDataType: messageDataType,
    );
  }
}
