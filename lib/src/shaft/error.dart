import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';



class NotImplementedShaftCalc extends StringShaftCalc {
  NotImplementedShaftCalc(
    super.shaftCalcChain, {
    required String message,
    StackTrace? stackTrace,
  }) : super(
          staticLabel: "<not implemented>",
          string: message,
        ) {
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
  }
}
