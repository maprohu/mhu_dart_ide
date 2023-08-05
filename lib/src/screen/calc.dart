import 'package:collection/collection.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';

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

List<MenuItem> emptyShaftOptions(ShaftBuilderBits shaftBuilderBits) => const [];

@Has()
@HasDefault(emptyShaftOptions)
typedef BuildShaftOptions = List<MenuItem> Function(ShaftBuilderBits shaftBits);

@Has()
typedef ShaftMsg = MdiShaftMsg;

@Has()
typedef ShaftCalcChainLeft = ShaftCalcChain?;

@Has()
typedef ShaftHeaderLabel = String;

@Has()
@HasDefault(true)
typedef ShaftSignificant = bool;

abstract class ShaftCalcBits implements HasShaftMsg, AppBits {}

@Compose()
abstract class ShaftCalcBuildBits implements ShaftCalcBits, HasShaftCalcChain {}

@Has()
@Compose()
abstract base class ShaftCalcChain implements AppBits, ShaftCalcBits {
  late final ShaftCalc calc = calculateShaft(this);

  late final ShaftCalcChain? shaftCalcChainLeft =
      shaftMsg.parentOpt?.let((parent) {
    return ComposedShaftCalcChain.appBits(
      appBits: this,
      shaftMsg: parent,
    );
  });
}

extension HasShaftMsgX on HasShaftMsg {
  int get shaftWidth => shaftMsg.widthOpt ?? 1;
}

@Has()
@Compose()
abstract class ShaftCalc
    implements
        ShaftCalcBits,
        HasShaftCalcChain,
        HasShaftHeaderLabel,
        HasBuildShaftContent,
        HasBuildShaftOptions,
        HasShaftSignificant {}

extension ShaftCalcChainX on ShaftCalcChain {
  ShaftCalcBuildBits get toBuildBits =>
      ComposedShaftCalcBuildBits.shaftCalcBits(
        shaftCalcBits: this,
        shaftCalcChain: this,
      );

  ShaftCalc? get leftCalc => shaftCalcChainLeft?.calc;

  Iterable<ShaftCalc> get leftCalcs => leftCalc.finiteIterable((item) => item.leftCalc);

  ShaftCalc? get leftSignificantCalc => leftCalcs.firstWhereOrNull((e) => e.shaftSignificant);
}

extension ShaftCalcX on ShaftCalc {
  ShaftCalc? get leftCalc => shaftCalcChain.leftCalc;
}

@Compose()
abstract class ShaftContentBits
    implements ShaftCalcBits, HasBuildShaftContent, HasBuildShaftOptions {}
