import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/switch.dart';

import '../builder/sized.dart';
import '../bx/boxed.dart';

class OptionsShaftCalc extends ShaftCalc {
  OptionsShaftCalc(super.shaftCalcChain)
      : super(
    staticLabel: "Options",
  );

  @override
  bool get isSignificant => false;

}

final ShaftCalcBuilder optionsShaftCalc = (shaftCalcChain) =>
    ComposedShaftCalc.shaftCalcChain(
      shaftCalcChain: shaftCalcChain,
      shaftHeaderLabel: "Options",
      buildShaftContent: (sizedBits) {
        return sizedBits.menu(
          items: [
            ...leftCalc!.buildShaftOptions(sizedBits.shaftBits),
            sizedBits.opener(
                  (shaft) => shaft.ensureMainMenu(),
            ),
          ],
        );
      },
    );
