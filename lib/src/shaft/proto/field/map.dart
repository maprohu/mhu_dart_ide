import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

ShaftBuilder mdiPfeMapFieldShaftBuilder({
  required MapFieldAccess access,
  required Mfw mfw,
}) {
  final ffu = access.fu(mfw);

  return (headerBits, contentBits) {
    return ShaftParts(
      header: headerBits.fillLeft(
        left: (sizedBits) => sizedBits.headerText.centerLeft(
          access.fieldKey.calc.protoName,
        ),
        right: headerBits.shaftBits.shortcut(() {}),
      ),
      content: contentBits.fill(),
    );
  };
}

class MapFieldOptions extends ConcreteFieldOptions {
  final MapFieldAccess access;

  MapFieldOptions(super.shaftCalc, this.access);

  @override
  List<MenuItem> options(ShaftBuilderBits nodeBits) {
    return [
      MenuItem(
        label: "Add New Item",
        callback: () {},
      ),
    ];
  }
}
