import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_ide/src/shaft/editing/int.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

// part 'string.g.has.dart';
// part 'int.g.compose.dart';

// @Compose()
// abstract class PfeShaftInt implements EditingShaftContentBits<int> {
//   static const headerLabel = "Edit Int";
//   static EditingShaftContentBits of({
//     required Fw<int?> fv,
//     required CoreIntDataType coreIntDataType,
//   }) {
//     return ComposedPfeShaftInt(
//       buildShaftContent: stringBuildShaftContent(fv().toString()),
//       buildShaftOptions: (shaftBuilderBits) => intEditOptions(
//         shaftBuilderBits: shaftBuilderBits,
//         currentValue: fv(),
//       ),
//       editingFw: fv,
//       scalarDataType: coreIntDataType,
//     );
//   }
// }
