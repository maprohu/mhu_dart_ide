import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

part 'edit_scalar.g.has.dart';
part 'edit_scalar.g.compose.dart';

@Has()
@Compose()
abstract class EditScalarShaftRight {}

@Compose()
abstract class EditScalarShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class EditScalarShaft
    implements
        ShaftCalcBuildBits,
        EditScalarShaftMerge,
        EditScalarShaftRight,
        ShaftCalc {
  static EditScalarShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {

    final shaftRight = ComposedEditScalarShaftRight();
    final shaftMerge = ComposedEditScalarShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        throw "todo";
      },
    );

    return ComposedEditScalarShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      editScalarShaftMerge: shaftMerge,
      editScalarShaftRight: shaftRight,
    );
  }
}
