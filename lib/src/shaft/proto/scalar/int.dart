import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/editing/int.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';

// part 'string.g.has.dart';
part 'int.g.compose.dart';

@Compose()
abstract class PfeShaftInt implements ShaftContentBits {
  static PfeShaftInt of({
    required Fw<int> fv,
  }) {
    return ComposedPfeShaftInt(
      buildShaftContent: stringBuildShaftContent(fv().toString()),
      buildShaftOptions: intEditOptions,
    );
  }
}
