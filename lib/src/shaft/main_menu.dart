import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/bx/screen.dart';
import 'package:mhu_dart_ide/src/context/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';

import '../long_running.dart';

part 'main_menu.g.has.dart';

part 'main_menu.g.compose.dart';

@Has()
@Compose()
abstract class MainMenuShaftLeft {}

@Compose()
abstract class MainMenuShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class MainMenuShaft
    implements
        ShaftCalcBuildBits,
        MainMenuShaftMerge,
        HasMainMenuShaftLeft,
        ShaftCalc {
  static MainMenuShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final shaftLeft = ComposedMainMenuShaftLeft();
    final shaftMerge = ComposedMainMenuShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        return sizedBits.menu(
          [
            ShaftTypes.config.opener(sizedBits),
            ShaftTypes.buildRunner.opener(sizedBits),
            MenuItem(
              label: "Reset View",
              callback: () {
                sizedBits.stateFw.rebuild((message) {
                  message.topShaft = defaultMainMenuShaft;
                });
              },
            ),
          ],
        ).toSingleElementIterable;
      },
    );

    return ComposedMainMenuShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      mainMenuShaftMerge: shaftMerge,
      mainMenuShaftLeft: shaftLeft,
    );
  }
}

@Compose()
abstract class MainMenuShaftFactory implements ShaftFactory {
  static MainMenuShaftFactory create() {
    return ComposedMainMenuShaftFactory.shaftFactory(
      shaftFactory: ShaftFactory(),
    );
  }
}
