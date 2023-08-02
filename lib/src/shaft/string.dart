import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_ide/src/string.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

Bx stringShaftBx({
  required SizedNodeBuilderBits sizedBits,
  required String label,
  required String string,
}) {
  return sizedBits.shaft((headerBits, contentBits) {
    return ShaftParts(
      header: headerBits.text(label),
      content: stringBx(
        sizedBits: contentBits,
        string: string,
      ),
    );
  });
}
