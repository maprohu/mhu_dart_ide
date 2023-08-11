import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

// part 'string.g.has.dart';
part 'string.g.compose.dart';

@Compose()
abstract class PfeShaftString implements EditingShaftContentBits<String> {
  static EditingShaftContentBits<String> of({
    required Fw<String?> fv,
    required StringDataType stringDataType,
  }) {
    final currentValue = fv();
    return ComposedPfeShaftString(
      buildShaftContent: (sizedBits) => [
        stringVerticalSharingBx(
          sizedBits: sizedBits,
          string: currentValue ?? "",
        ),
        ...sizedBits.menu(items: [
          sizedBits.openerField(
            MdiShaftMsg$.editScalar,
            before: (shaftMsg) {
              sizedBits.accessInnerStateRight(
                (innerStateFw) async {
                  innerStateFw.value = MdiInnerStateMsg$.create(
                    editString: MdiInnerEditStringMsg$.create(
                      text: currentValue ?? "",
                    ),
                  )..freeze();
                },
              );
            },
            autoFocus: true,
            label: "Edit String",
          ),
        ]),
      ],
      editingFw: fv,
      scalarDataType: stringDataType,
    );
  }
}
