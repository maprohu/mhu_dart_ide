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
  logger.e(
    message,
    error,
    stackTrace ?? StackTrace.current,
  );

  return stringShaftBx(
    sizedBits: sizedBits,
    label: 'error',
    string: message,
  );
}
