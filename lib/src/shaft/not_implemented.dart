import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/app.dart';

// import '../screen/shaft_factory.dart';

// import 'not_implemented.dart' as $lib;
// part 'not_implemented.g.has.dart';
// part 'not_implemented.g.dart';

// part 'not_implemented.g.has.dart';
//
// part 'not_implemented.g.compose.dart';
//
// @Has()
// @Compose()
// abstract class NotImplementedShaftRight {}
//
// @Compose()
// abstract class NotImplementedShaftMerge implements ShaftMergeBits {}
//
// @Compose()
// abstract class NotImplementedShaft
//     implements
//         ShaftCalcBuildBits,
//         NotImplementedShaftMerge,
//         NotImplementedShaftRight,
//         ShaftCalc {
//   static NotImplementedShaft create(
//     ShaftCalcBuildBits shaftCalcBuildBits,
//   ) {
//     MhuLogger.cut1.w(
//       "shaft not implemented: ${shaftCalcBuildBits.shaftType}",
//       null,
//       StackTrace.current,
//     );
//
//     final shaftRight = ComposedNotImplementedShaftRight();
//     final shaftMerge = ComposedNotImplementedShaftMerge(
//       shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
//       buildShaftContent: (sizedBits) {
//         return const [];
//       },
//     );
//
//     return ComposedNotImplementedShaft.merge$(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       notImplementedShaftMerge: shaftMerge,
//       notImplementedShaftRight: shaftRight,
//     );
//   }
// }

// @Compose()
// abstract class NotImplementedShaftFactory implements ShaftFactory {
//   static NotImplementedShaftFactory create() {
//     return ComposedNotImplementedShaftFactory.shaftFactory(
//       shaftFactory: createShaftFactory(),
//     );
//   }
// }
