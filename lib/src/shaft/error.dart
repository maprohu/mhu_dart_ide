import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

Bx errorShaftBx({
  required SizedNodeBuilderBits sizedBits,
  required String message,
  dynamic error,
  StackTrace? stackTrace,
}) {
  if (stackTrace == null) {
    MhuLogger.cut1.e(
      message,
      error,
      StackTrace.current,
    );
  } else {
    logger.e(
      message,
      error,
      stackTrace,
    );
  }

  return stringShaftBx(
    sizedBits: sizedBits,
    label: 'error',
    string: message,
  );
}
