import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

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
