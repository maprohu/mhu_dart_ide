import 'package:collection/collection.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/bx/screen.dart';
import 'package:mhu_dart_ide/src/model.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:recase/recase.dart';

import '../builder/sized.dart';
import '../bx/menu.dart';
import '../bx/share.dart';
import '../config.dart';
import '../op.dart';
import '../shaft/switch.dart';
import '../bx/boxed.dart';

part 'calc.g.has.dart';

part 'calc.g.compose.dart';

@Has()
typedef BuildShaftContent = Iterable<SharingBx> Function(
  SizedShaftBuilderBits sizedBits,
);

List<MenuItem> emptyShaftOptions(ShaftBuilderBits shaftBuilderBits) => const [];

@Has()
@HasDefault(emptyShaftOptions)
typedef BuildShaftOptions = List<MenuItem> Function(
    ShaftBuilderBits shaftBuilderBits);

@Has()
typedef ShaftMsg = MdiShaftMsg;
@Has()
typedef StateMsg = MdiStateMsg;

@Has()
typedef ShaftCalcChainLeft = ShaftCalcChain?;

@Has()
typedef ShaftHeaderLabel = String;

@Has()
@HasDefault(true)
typedef ShaftSignificant = bool;

abstract class ShaftCalcBits implements HasShaftMsg, HasStateMsg, AppBits {}

@Has()
typedef ShaftStateField<T> = ScalarFieldAccess<MdiShaftMsg, T>;

@Compose()
abstract class ShaftCalcBuildBits<T>
    implements ShaftCalcBits, HasShaftCalcChain, HasShaftStateField<T> {}

@Has()
typedef ShaftIndexFromRight = int;
@Has()
typedef ShaftIndexFromLeft = int;

@Has()
@Compose()
abstract base class ShaftCalcChain
    implements AppBits, ShaftCalcBits, HasShaftIndexFromRight {
  late final ShaftCalc calc = calculateShaft(this);

  late final ShaftCalcChain? shaftCalcChainLeft =
      shaftMsg.parentOpt?.let((parent) {
    return ComposedShaftCalcChain.appBits(
      appBits: this,
      shaftMsg: parent,
      shaftIndexFromRight: shaftIndexFromRight + 1,
      stateMsg: stateMsg,
    );
  });

  late final ShaftIndexFromLeft shaftIndexFromLeft =
      shaftCalcChainLeft?.shaftIndexFromLeft.let((i) => i + 1) ?? 0;

  late final isFocused =
      shaftIndexFromLeft == stateMsg.focusedShaft.indexFromLeftOpt;
}

extension HasShaftMsgX on HasShaftMsg {
  int get shaftWidth => shaftMsg.widthOpt ?? 1;
}

@Has()
@Compose()
abstract class ShaftCalc<T>
    implements
        ShaftCalcBuildBits<T>,
        ShaftLabeledContentBits,
        ShaftCalcBits,
        HasShaftCalcChain,
        HasShaftHeaderLabel,
        HasBuildShaftContent,
        HasBuildShaftOptions,
        HasShaftSignificant,
        HasShaftStateField<T> {}

extension ShaftCalcChainX on ShaftCalcChain {
  ShaftCalcBuildBits toBuildBits({
    required ShaftStateField shaftStateField,
  }) =>
      ComposedShaftCalcBuildBits.shaftCalcBits(
        shaftCalcBits: this,
        shaftCalcChain: this,
        shaftStateField: shaftStateField,
      );

  ShaftCalc? get leftCalc => shaftCalcChainLeft?.calc;

  Iterable<ShaftCalc> get leftCalcs =>
      leftCalc.finiteIterable((item) => item.leftCalc);

  ShaftCalc? get leftSignificantCalc =>
      leftCalcs.firstWhereOrNull((e) => e.shaftSignificant);

  Fu<MdiShaftMsg> get shaftMsgFu {
    return Fu.fromFr(
      fr: stateFw.map((state) {
        return state.effectiveTopShaft.getShaftByIndex(shaftIndexFromRight);
      }),
      update: (updates) {
        stateFw.deepRebuild((state) {
          state.topShaftOpt?.clearNotificationsDeepMutate();
          state.effectiveTopShaft
              .getShaftByIndex(shaftIndexFromRight)
              .let(updates);
        });
      },
    );
  }
}

extension ShaftCalcX on ShaftCalc {
  // ShaftCalc? get leftCalc => shaftCalcChain.leftCalc;
}

extension HasShaftCalcChainX on HasShaftCalcChain {
  ShaftCalc? get leftCalc => shaftCalcChain.leftCalc;
}

@Compose()
abstract class ShaftContentBits
    implements HasBuildShaftContent, HasBuildShaftOptions {}

@Compose()
abstract class ShaftLabeledContentBits
    implements ShaftContentBits, HasShaftHeaderLabel {}

extension ShaftCalcBxX on Bx {
  SharingBx get shaftContentSharing => SharingBx.fixedVertical(this);
}

extension ShaftCalcBuildBitsX<T> on ShaftCalcBuildBits<T> {
  String get defaultShaftHeaderLabel => shaftStateField.name.titleCase;
}
