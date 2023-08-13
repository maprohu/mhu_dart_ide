import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';
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
    switch (dataType) {
      case ScalarDataType():
        return scalar(
          scalarDataType: dataType,
          scalarValue: messageValue.scalarAttribute(
            messageUpdateBits: messageUpdateBits,
            scalarAttribute: dataType.scalarAttribute(
              fieldCoordinates: fieldCoordinates,
            ),
          ),
        );
      case MapDataType():
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

      return builder(scalarEditingBits) as ValueBrowsingContent<T>;
    }

    final ScalarDataType sdt = scalarDataType;
    switch (sdt) {
      case MessageDataType():
        throw "todo";
      case CoreIntDataType():
        return build(sdt, coreIntType);

      default:
        throw scalarDataType;
    }
  }

  static ValueBrowsingContent<int> coreIntType(
    ScalarEditingBits<int> scalarEditingBits,
  ) {
    return ComposedValueBrowsingContent(
      buildShaftContent: stringBuildShaftContent(
        scalarEditingBits.watchValue().toString(),
      ),
      editingBits: scalarEditingBits,
    );
  }
}
