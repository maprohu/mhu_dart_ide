import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_ide/src/string.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';

import '../screen.dart';
import '../screen/calc.dart';
import '../widgets/boxed.dart';

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
