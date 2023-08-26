import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/app.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/screen/calc.dart';

import '../shaft_factory.dart';

// import 'main_menu.dart' as $lib;

// part 'main_menu.g.has.dart';

// @Has()
// @Compose()
// abstract class MainMenuShaftLeft {}
//
// @Compose()
// abstract class MainMenuShaftMerge implements ShaftMergeBits {}
//
// @Compose()
// abstract class MainMenuShaft
//     implements
//         ShaftCalcBuildBits,
//         MainMenuShaftMerge,
//         HasMainMenuShaftLeft,
//         ShaftCalc {
//   static MainMenuShaft create(
//     ShaftCalcBuildBits shaftCalcBuildBits,
//   ) {
//     final shaftLeft = ComposedMainMenuShaftLeft();
//     final shaftMerge = ComposedMainMenuShaftMerge(
//       shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//       buildShaftContent: (sizedBits) {
//         return sizedBits.menu(
//           [
//             ShaftTypes.config.opener(sizedBits),
//             ShaftTypes.buildRunner.opener(sizedBits),
//             MenuItem(
//               label: "Reset View",
//               callback: () {
//                 sizedBits.windowStateFw.rebuild((message) {
//                   message.topShaft = defaultMainMenuShaft;
//                 });
//               },
//             ),
//           ],
//         ).toSingleElementIterable;
//       },
//     );
//
//     return ComposedMainMenuShaft.merge$(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       mainMenuShaftMerge: shaftMerge,
//       mainMenuShaftLeft: shaftLeft,
//     );
//   }
// }

class MainMenuShaftFactory extends ShaftFactoryHolder {
  @override
  final factory = ComposedShaftFactory.shaftLabel(
    shaftLabel: staticShaftLabel("Main Menu"),
    createShaftData: voidShaftData,
    requestShaftFocus: shaftWithoutFocus,
    createShaftContent: shaftMenuContent(
      (shaftData, shaftCtx) {
        return [
          menuItemStatic(
            action: shaftCtx.windowResetView,
            label: "Reset View",
          ),
        ];
      },
    ),
  );
}
