import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/editing/string.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

part 'edit_scalar.g.has.dart';

part 'edit_scalar.g.compose.dart';

@Has()
@Compose()
abstract class EditScalarShaftRight {}

@Compose()
abstract class EditScalarShaftMerge
    implements HasShaftHeaderLabel, ShaftContentBits, HasShaftInitState {}

@Compose()
abstract class EditScalarShaft
    implements
        ShaftCalcBuildBits,
        EditScalarShaftRight,
        EditScalarShaftMerge,
        ShaftCalc {
  static EditScalarShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final left = shaftCalcBuildBits.leftCalc as HasEditingBits;

    final scalarEditingBits = left.editingBits as ScalarEditingBits;

    return scalarEditingBits.scalarEditingBitsGeneric(<T>(scalarEditingBits) {
      final shaftRight = ComposedEditScalarShaftRight();

      final ScalarDataType sdt = scalarEditingBits.scalarDataType;
      final merge = switch (sdt) {
        StringDataType() => stringType(scalarEditingBits: scalarEditingBits),
        CoreIntDataType() => ComposedEditScalarShaftMerge(
            shaftHeaderLabel: "Edit Int",
            buildShaftContent: (sizedBits) {
              throw "todo";
            },
          ),
        final other => throw other,
      };

      return ComposedEditScalarShaft.merge$(
        shaftCalcBuildBits: shaftCalcBuildBits,
        editScalarShaftMerge: merge,
        editScalarShaftRight: shaftRight,
        shaftAutoFocus: true,
      );
    });
  }

  static EditScalarShaftMerge stringType<T>({
    required ScalarEditingBits<T> scalarEditingBits,
  }) {
    final bits = scalarEditingBits as ScalarEditingBits<String>;
    return ComposedEditScalarShaftMerge(
      shaftHeaderLabel: "Edit String",
      buildShaftContent: (sizedBits) {
        return editScalarAsStringSharingBoxes(
          sizedBits: sizedBits,
          stringParsingBits: StringParsingBits.stringType(
            submitValue: (value) {
              bits.writeValue(value);
              sizedBits.closeShaft();
            },
          ),
        );
      },
      shaftInitState: () {
        final text = bits.readValue() ?? "";
        return MdiInnerStateMsg()
          ..ensureStringEdit().text = text
          ..freeze();
      },
    );
  }
}
