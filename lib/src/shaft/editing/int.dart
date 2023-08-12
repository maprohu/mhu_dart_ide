import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/bx/share.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/inner_state.dart';
import 'package:mhu_dart_ide/src/screen/notification.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_ide/src/shaft/editing/string.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/widgets/async.dart';
import 'package:mhu_dart_ide/src/widgets/busy.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:protobuf/protobuf.dart';

import '../../bx/boxed.dart';
import '../../bx/padding.dart';
import '../../keyboard.dart';
import '../proto/scalar/int.dart';

// part 'int.g.has.dart';
// part 'int.g.compose.dart';

List<MenuItem> intEditOptions({
  required ShaftBuilderBits shaftBuilderBits,
  required int? currentValue,
}) {
  return [
    ShaftTypes.editScalar.opener(
      shaftBuilderBits,
      innerState: () {
        return MdiInnerStateMsg()
          ..ensureEditInt().text = currentValue?.toString() ?? ""
          ..freeze();
      },
    ),
  ];
}

final _maxLength = 0x7FFFFFFF.toString().length;

// @Compose()
// abstract class EditScalarIntBits
//     implements
//         EditScalarShaftBits<int>,
//         EditingShaftContentBits<int>,
//         EditingShaftLabeledContentBits<int> {
//   static const headerLabel = "Edit Int";
//
//   static EditScalarIntBits create({
//     required EditScalarShaftBits<int> editScalarShaftBits,
//   }) {
//     return ComposedEditScalarIntBits.editScalarShaftBits(
//       editScalarShaftBits: editScalarShaftBits,
//       buildShaftContent: editScalarAsStringBuildShaftContent<int>(
//         onSubmit: editScalarShaftBits.editingFw.set,
//         parser: (string) {
//           try {
//             return ValidationSuccessImpl(
//               int.parse(string),
//             );
//           } catch (e) {
//             return ValidationFailureImpl(
//               [e.toString()],
//             );
//           }
//         },
//         textAttribute: MdiInnerStateMsg$.editInt.thenReadWrite(
//           MdiInnerEditIntMsg$.text,
//         ),
//         maxStringLength: _maxLength,
//       ),
//       shaftHeaderLabel: headerLabel,
//     );
//   }
// }
