import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

import '../builder/sized.dart';
import '../bx/boxed.dart';

class OptionsShaftCalc extends ShaftCalc {
  OptionsShaftCalc(super.shaftCalcChain)
      : super(
          staticLabel: "Options",
        );

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    return sizedBits.menu(
      items: [
        ...leftCalc!.options(sizedBits.shaftBits),
        sizedBits.opener(
          (shaft) => shaft.ensureMainMenu(),
        ),
      ],
    );
  }
}
