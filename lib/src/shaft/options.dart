import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/bx/long_running.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/context/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';

import '../long_running.dart';

part 'options.g.has.dart';

part 'options.g.compose.dart';

@Has()
@Compose()
abstract class OptionsShaftLeft {}

@Compose()
abstract class OptionsShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class OptionsShaft
    implements
        ShaftCalcBuildBits,
        OptionsShaftMerge,
        HasOptionsShaftLeft,
        ShaftCalc {
  static OptionsShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final shaftLeft = ComposedOptionsShaftLeft();
    final shaftMerge = ComposedOptionsShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      shaftSignificant: false,
      buildShaftContent: (sizedBits) {
        final shaftLeft = sizedBits.shaftMsg.parentOpt;
        final parentOfShaftLeft = shaftLeft?.parentOpt;
        final tasksContent = longRunningTasksShaftContent(appBits: sizedBits);
        return [
          sizedBits.menu(
            [
              // ...shaftCalcBuildBits.leftCalc!.buildShaftOptions(sizedBits),
              ShaftTypes.mainMenu.opener(sizedBits),
              if (parentOfShaftLeft != null)
                MenuItem(
                  label: "Close Shaft",
                  callback: () {
                    sizedBits.stateFw.rebuild(
                      (message) {
                        message.topShaft = parentOfShaftLeft;
                      },
                    );
                  },
                ),
            ],
          ),
          if (tasksContent != null) ...tasksContent(sizedBits),
        ];
      },
    );

    return ComposedOptionsShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      optionsShaftMerge: shaftMerge,
      optionsShaftLeft: shaftLeft,
    );
  }
}

@Compose()
abstract class OptionsShaftFactory implements ShaftFactory {
  static OptionsShaftFactory create() {
    return ComposedOptionsShaftFactory.shaftFactory(
      shaftFactory: ShaftFactory(),
    );
  }
}


