import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';
import 'package:mhu_dart_ide/src/bx/shaft.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';

import '../builder/sized.dart';
import '../screen/calc.dart';
import '../bx/boxed.dart';

Bx stringShaftBx({
  required SizedShaftBuilderBits sizedBits,
  required String label,
  required String string,
}) {
  return sizedBits.shaft((headerBits, contentBits) {
    return ShaftParts(
      header: headerBits.headerText.centerLeft(label),
      content: stringBx(
        sizedBits: contentBits,
        string: string,
      ),
    );
  });
}

BuildShaftContent stringBuildShaftContent(String string) => (sizedBits) {
      return stringBx(
        sizedBits: sizedBits,
        string: string,
      );
    };
