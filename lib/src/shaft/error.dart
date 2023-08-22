import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/shaft_factory.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';
import 'package:mhu_dart_ide/src/shaft/switch.dart';

// part 'error.g.has.dart';
part 'error.g.compose.dart';

ShaftCalc notImplementedShaftCalc({
  required ShaftCalcBuildBits shaftCalcBuildBits,
  required String message,
  StackTrace? stackTrace,
}) {
  if (stackTrace == null) {
    MhuLogger.cut1.e(
      message,
      message,
      StackTrace.current,
    );
  } else {
    logger.e(
      message,
      message,
      stackTrace,
    );
  }

  return ComposedShaftCalc.shaftCalcBuildBits(
    shaftCalcBuildBits: shaftCalcBuildBits,
    shaftHeaderLabel: "<not implemented>",
    buildShaftContent: stringBuildShaftContent(message),
  );
}

@Compose()
abstract class InvalidShaftFactory implements ShaftFactory {
  static InvalidShaftFactory create() {
    return ComposedInvalidShaftFactory.shaftFactory(
      shaftFactory: ShaftFactory(),
    );
  }
}
