import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

part 'build_runner.g.has.dart';
part 'build_runner.g.compose.dart';

@Has()
@Compose()
abstract class BuildRunnerShaftRight {}

@Compose()
abstract class BuildRunnerShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class BuildRunnerShaft
    implements
        ShaftCalcBuildBits,
        BuildRunnerShaftMerge,
        BuildRunnerShaftRight,
        ShaftCalc {
  static BuildRunnerShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {

    final shaftRight = ComposedBuildRunnerShaftRight();
    final shaftMerge = ComposedBuildRunnerShaftMerge(
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      buildShaftContent: (sizedBits) {
        throw "todo";
      },
    );

    return ComposedBuildRunnerShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      buildRunnerShaftMerge: shaftMerge,
      buildRunnerShaftRight: shaftRight,
    );
  }
}


// import 'package:mhu_dart_ide/src/bx/shaft.dart';
//
// import '../builder/sized.dart';
// import '../bx/menu.dart';
// import '../bx/boxed.dart';
//
// Bx mdiBuildRunnerMenuShaftBx({
//   required SizedShaftBuilderBits sizedBits,
// }) {
//   return sizedBits.menuShaft(
//     label: "Build Runner",
//     items: [
//       MenuItem(
//         label: "Settings",
//         callback: () {
//           print('settings');
//         },
//       ),
//     ],
//   );
// }
