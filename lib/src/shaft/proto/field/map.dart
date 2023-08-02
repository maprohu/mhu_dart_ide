import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/shaft.dart';
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
        right: headerBits.nodeBits.shortcut(() {}),
      ),
      content: contentBits.fill(),
    );
  };
}
