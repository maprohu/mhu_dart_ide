import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/editing/string.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

import 'int.dart';

part 'editing.g.has.dart';

part 'editing.g.compose.dart';

@Has()
typedef EditingFw<T> = Fw<T>;

@Compose()
@Has()
abstract class EditScalarShaftBits<T>
    implements HasEditingFw<T?>, HasScalarDataType<T> {}

abstract class EditingShaftContentBits<T>
    implements ShaftContentBits, EditScalarShaftBits<T> {}

@Compose()
abstract class EditingShaftLabeledContentBits<T>
    implements
        ShaftLabeledContentBits,
        EditingShaftContentBits<T>,
        HasShaftHeaderLabel {}

ShaftCalc editScalarShaftCalc(ShaftCalcBuildBits shaftCalcBuildBits) {
  final leftBits = shaftCalcBuildBits.leftCalc as HasScalarDataType;

  return ComposedShaftCalc.merge$(
    shaftCalcBuildBits: shaftCalcBuildBits,
    shaftLabeledContentBits: leftBits.scalarDataType.dataTypeGeneric(
      <T>() => editScalarShaftLabeledContentBits(
        editScalarShaftBits: leftBits as EditScalarShaftBits<T>,
      ),
    ),
  );
}

EditingShaftLabeledContentBits<T> editScalarShaftLabeledContentBits<T>({
  required EditScalarShaftBits<T> editScalarShaftBits,
}) {
  final ScalarDataType scalarDataType = editScalarShaftBits.scalarDataType;

  final EditingShaftLabeledContentBits result = switch (scalarDataType) {
    StringDataType() => EditScalarStringBits.create(
      editScalarShaftBits: editScalarShaftBits as EditScalarShaftBits<String>,
    ),
    CoreIntDataType() => EditScalarIntBits.create(
        editScalarShaftBits: editScalarShaftBits as EditScalarShaftBits<int>,
      ),
    final other => throw other,
  };

  return result as EditingShaftLabeledContentBits<T>;
}

@Compose()
abstract class MessageEditingBits<M extends GeneratedMessage>
    implements EditScalarShaftBits<M>, HasMessageDataType<M> {
  static MessageEditingBits<M> create<M extends GeneratedMessage>({
    required Fw<M?> editingFw,
    required MessageDataType<M> messageDataType,
  }) {
    return ComposedMessageEditingBits(
      editingFw: editingFw,
      scalarDataType: messageDataType,
      messageDataType: messageDataType,
    );
  }
}
