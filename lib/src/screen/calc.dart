import 'package:collection/collection.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:recase/recase.dart';

import '../builder/sized.dart';
import '../bx/menu.dart';
import '../config.dart';
import '../op.dart';
import '../shaft/switch.dart';
import '../bx/boxed.dart';

part 'calc.g.has.dart';

part 'calc.g.compose.dart';

@Has()
typedef BuildShaftContent = Bx Function(SizedShaftBuilderBits sizedBits);
@Has()
typedef BuildShaftOptions = List<MenuItem> Function(
    ShaftBuilderBits shaftBits)?;

@Has()
typedef ShaftMsg = MdiShaftMsg;

@Has()
typedef ShaftCalcLeft = ShaftCalcChain?;

@Has()
typedef ShaftHeaderLabel = String;

@Has()
typedef ShaftSignificant = bool?;

extension HasShaftSignificanceX on HasShaftSignificant {
  bool get effectiveShaftSignificant => shaftSignificant ?? false;
}

abstract class ShaftCalcBits implements HasShaftMsg, AppBits {}

@Has()
@Compose()
abstract class ShaftCalcChain implements ShaftCalcBits, HasShaftCalcLeft {
  // @override
  // final MdiAppBits appBits;
  // @override
  // final MdiShaftMsg shaftMsg;
  //
  // @override
  // late final ShaftCalcChain? parent = shaftMsg.parentOpt?.let((parent) {
  //   return ShaftCalcChain(
  //     appBits: appBits,
  //     shaftMsg: parent,
  //   );
  // });
  //
  // late final ShaftCalc calc = calculateShaft(this);
  //
  // ShaftCalcChain({
  //   required this.appBits,
  //   required this.shaftMsg,
  // });
}

// mixin HasShaftMsg {
//   MdiShaftMsg get shaftMsg;
//
//   late final shaftWidth = shaftMsg.widthOpt ?? 1;
// }

// mixin HasShaftCalcChain {
//   ShaftCalcChain get shaftCalcChain;
//
//   late final shaftMsg = shaftCalcChain.shaftMsg;
// }

@Has()
@Compose()
abstract class ShaftCalc
    implements
        ShaftCalcBits,
        HasShaftCalcChain,
        HasShaftHeaderLabel,
        HasBuildShaftContent,
        HasBuildShaftOptions,
        HasShaftSignificant {
  // @override
  // final ShaftCalcChain shaftCalcChain;
  // final String staticLabel;
  //
  // @override
  // BuildShaftOptions get buildShaftOptions => (shaftBits) => const [];
  //
  // bool get isSignificant => true;
  //
  // ShaftCalc(
  //   this.shaftCalcChain, {
  //   this.staticLabel = "<no label>",
  // });
  //
  // ShaftCalc.access(
  //   this.shaftCalcChain, {
  //   required ScalarFieldAccess<MdiShaftMsg, dynamic> access,
  // }) : staticLabel = access.name.titleCase;
  //
  // String get label => staticLabel;
  //
  // late final leftCalc = shaftCalcChain.parent?.calc;
  //
  // late final leftSignificantCalc = shaftCalcChain.childToParentIterable
  //     .map((e) => e.calc)
  //     .firstWhereOrNull((e) => e.isSignificant);
}

// mixin HasShaftCalc {
//   ShaftCalc get shaftCalc;
//
//   late final shaftCalcChain = shaftCalc.shaftCalcChain;
// }

// mixin DelegateShaftCalcOptions {
//   List<MenuItem> Function(ShaftBuilderBits shaftBits) get optionsDelegate;
//
//   List<MenuItem> options(ShaftBuilderBits shaftBits) =>
//       optionsDelegate(shaftBits);
// }

// mixin ShaftCalcRightOf<T extends ShaftCalc> implements ShaftCalc {
//   late final typedLeftCalc = leftSignificantCalc as T;
// }
