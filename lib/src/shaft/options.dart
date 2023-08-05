import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';



ShaftCalc optionsShaftCalc(ShaftCalcChain shaftCalcChain) =>
    ComposedShaftCalc.shaftCalcBits(
      shaftCalcBits: shaftCalcChain,
      shaftCalcChain: shaftCalcChain,
      shaftHeaderLabel: "Options",
      shaftSignificant: false,
      buildShaftContent: (sizedBits) {
        return sizedBits.menu(
          items: [
            ...shaftCalcChain.leftCalc!.buildShaftOptions(sizedBits),
            sizedBits.opener(
                  (shaft) => shaft.ensureMainMenu(),
            ),
          ],
        );
      },
    );
