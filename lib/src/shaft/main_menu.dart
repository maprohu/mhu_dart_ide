import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/switch.dart';

import '../builder/sized.dart';
import '../bx/menu.dart';
import '../bx/boxed.dart';

final ShaftCalcBuilder mainMenuShaftCalc = (shaftCalcChain) => ComposedShaftCalc.shaftCalcBits(
  shaftCalcBits: shaftCalcChain,
  shaftCalcChain: shaftCalcChain,
  shaftHeaderLabel: "Main Menu",
  buildShaftContent: (SizedShaftBuilderBits sizedBits) {
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
                parent: sizedBits.shaftMsg,
              )..ensureBuildRunner();
            });
          }),
        ),
      ],
    );
  },
);

