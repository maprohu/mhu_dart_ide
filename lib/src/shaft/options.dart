
import '../shaft_factory.dart';

// part 'options.g.has.dart';
//
// part 'options.g.compose.dart';
//
// @Has()
// @Compose()
// abstract class OptionsShaftLeft {}
//
// @Compose()
// abstract class OptionsShaftMerge implements ShaftMergeBits {}
//
// @Compose()
// abstract class OptionsShaft
//     implements
//         ShaftCalcBuildBits,
//         OptionsShaftMerge,
//         HasOptionsShaftLeft,
//         ShaftCalc {
//   static OptionsShaft create(
//     ShaftCalcBuildBits shaftCalcBuildBits,
//   ) {
//     final shaftLeft = ComposedOptionsShaftLeft();
//     final shaftMerge = ComposedOptionsShaftMerge(
//       shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//       shaftSignificant: false,
//       buildShaftContent: (sizedBits) {
//         final shaftLeft = sizedBits.shaftMsg.parentOpt;
//         final parentOfShaftLeft = shaftLeft?.parentOpt;
//         final tasksContent = longRunningTasksShaftContent(appBits: sizedBits);
//         return [
//           sizedBits.menu(
//             [
//               // ...shaftCalcBuildBits.leftCalc!.buildShaftOptions(sizedBits),
//               ShaftTypes.mainMenu.opener(sizedBits),
//               if (parentOfShaftLeft != null)
//                 MenuItem(
//                   label: "Close Shaft",
//                   callback: () {
//                     sizedBits.windowStateFw.rebuild(
//                       (message) {
//                         message.topShaft = parentOfShaftLeft;
//                       },
//                     );
//                   },
//                 ),
//             ],
//           ),
//           if (tasksContent != null) ...tasksContent(sizedBits),
//         ];
//       },
//     );
//
//     return ComposedOptionsShaft.merge$(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       optionsShaftMerge: shaftMerge,
//       optionsShaftLeft: shaftLeft,
//     );
//   }
// }

class OptionsShaftFactory extends ShaftFactoryHolder {
  @override
  final factory = ComposedShaftFactory(
    createShaftData: voidShaftData,
    createShaftHeaderLabel: staticShaftHeaderLabel("Options"),
    requestShaftFocus: shaftWithoutFocus,
  );
}
