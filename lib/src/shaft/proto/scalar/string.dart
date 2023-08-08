import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';

// part 'string.g.has.dart';
part 'string.g.compose.dart';

@Compose()
abstract class PfeShaftString implements EditingShaftContentBits<String?> {
  static EditingShaftContentBits of({
    required Fw<String?> fv,
  }) {
    return ComposedPfeShaftString(
      buildShaftContent: stringBuildShaftContent(fv() ?? ""),
      editingFw: fv,
    );
  }
}
