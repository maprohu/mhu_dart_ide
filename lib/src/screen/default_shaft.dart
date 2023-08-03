import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';

import '../widgets/boxed.dart';
import 'options.dart';

Bx defaultShaftBx({
  required SizedShaftBuilderBits sizedBits,
  required ShaftCalc shaftCalc,
}) {
  return shaftBx(
    sizedBits: sizedBits,
    builder: (headerBits, contentBits) {
      return ShaftParts(
        header: headerBits.fillLeft(
          left: (sizedBits) => sizedBits.headerText.centerLeft(
            shaftCalc.label,
          ),
          right: headerBits.centerHeight(
            headerBits.shaftBits.shortcut(
              headerBits.optionsOpenerCallback(),
            ),
          ),
        ),
        content: shaftCalc.content(contentBits),
      );
    },
  );
}
