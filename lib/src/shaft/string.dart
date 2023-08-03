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

class StringShaftCalc extends ShaftCalc {
  final String string;

  StringShaftCalc(
    super.shaftCalcChain, {
    required super.staticLabel,
    required this.string,
  });

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    return stringBx(
      sizedBits: sizedBits,
      string: string,
    );
  }
}
