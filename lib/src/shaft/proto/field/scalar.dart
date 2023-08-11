import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/shaft/proto/scalar/string.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import '../../../app.dart';
import '../../../config.dart';
import '../../../op.dart';
import '../../../screen/calc.dart';
import '../../editing/editing.dart';
import '../concrete_field.dart';

// part 'scalar.g.has.dart';
part 'scalar.g.compose.dart';

@Compose()
abstract class PfeShaftScalarField<T>
    implements
        PfeShaftConcreteFieldBits,
        EditingShaftContentBits<T>,
        PfeShaftConcreteField {
  static PfeShaftScalarField<T> of<T>({
    required PfeShaftConcreteFieldBits pfeShaftConcreteFieldBits,
    required ScalarDataType<T> scalarDataType,
    required Mfw mfw,
  }) {
    assert(T != dynamic);

    final fieldFw = scalarDataType.fwForField(
      fieldCoordinates:
      pfeShaftConcreteFieldBits.concreteFieldKey.concreteFieldCalc,
      mfw: mfw,
    );

    final ScalarDataType sdt = scalarDataType;
    final content = switch (sdt) {
      StringDataType() => PfeShaftString.of(
        fv: fieldFw as Fw<String?>,
        stringDataType: sdt,
      ),
      final other => throw other,
    };

    return ComposedPfeShaftScalarField.merge$(
      pfeShaftConcreteFieldBits: pfeShaftConcreteFieldBits,
      editingShaftContentBits: content as EditingShaftContentBits<T>,
    );
  }
}
