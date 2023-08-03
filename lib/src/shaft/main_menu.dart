import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

class MainMenuShaftCalc extends ShaftCalc {
  MainMenuShaftCalc(super.shaftCalcChain)
      : super(
          staticLabel: "Main Menu",
        );

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    return sizedBits.menu(
      items: [
        sizedBits.opener(
          (shaft) => shaft.ensureConfig(),
        ),
        MenuItem(
          label: "theme",
          callback: (() {}),
        ),
        MenuItem(
          label: "state",
          callback: (() {}),
        ),
        MenuItem(
          label: "build_runner",
          callback: (() {
            sizedBits.configBits.state.rebuild((message) {
              message.topShaft = MdiShaftMsg$.create(
                buildRunner: MdiBuildRunnerMenuMsg(),
                parent: sizedBits.shaftMsg,
              );
            });
          }),
        ),
      ],
    );
  }
}
