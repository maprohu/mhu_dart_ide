import '../shaft_factory.dart';

// // part 'error.g.has.dart';
//
// ShaftCalc notImplementedShaftCalc({
//   required ShaftCalcBuildBits shaftCalcBuildBits,
//   required String message,
//   StackTrace? stackTrace,
// }) {
//   if (stackTrace == null) {
//     MhuLogger.cut1.e(
//       message,
//       message,
//       StackTrace.current,
//     );
//   } else {
//     logger.e(
//       message,
//       message,
//       stackTrace,
//     );
//   }
//
//   return ComposedShaftCalc.shaftCalcBuildBits(
//     shaftCalcBuildBits: shaftCalcBuildBits,
//     shaftHeaderLabel: "<not implemented>",
//     buildShaftContent: stringBuildShaftContent(message),
//   );
// }

class InvalidShaftFactory extends ShaftFactoryHolder {
  @override
  final factory = ComposedShaftFactory.shaftLabel(
    shaftLabel: staticShaftLabel("Invalid"),
    createShaftData: voidShaftData,
    requestShaftFocus: shaftWithoutFocus,
    createShaftContent: (shaftData) => (rectCtx) => [],
  );
}
