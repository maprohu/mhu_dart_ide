import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

ShaftBuilder mdiPfeMapFieldShaftBuilder({
  required MapFieldAccess mapFieldAccess,
  required Mfw mfw,
}) {
  final ffu = mapFieldAccess.fu(mfw);

  return (headerBits, contentBits) {
    return ShaftParts(
      header: headerBits.he,
      content: contentBits.fill(),
    );
  };
}
