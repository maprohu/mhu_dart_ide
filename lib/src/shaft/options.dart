import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';



ShaftCalc optionsShaftCalc(ShaftCalcBuildBits shaftCalcBuildBits) =>
    ComposedShaftCalc.shaftCalcBuildBits(
      shaftCalcBuildBits: shaftCalcBuildBits,
      shaftHeaderLabel: "Options",
      shaftSignificant: false,
      buildShaftContent: (sizedBits) {
        return sizedBits.menu(
          items: [
            ...shaftCalcBuildBits.leftCalc!.buildShaftOptions(sizedBits),
            sizedBits.opener(
                  (shaft) => shaft.ensureMainMenu(),
            ),
          ],
        );
      },
    );
