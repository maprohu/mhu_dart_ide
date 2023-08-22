import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/bx/screen.dart';
import 'package:mhu_dart_ide/src/context/rect.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

part 'shaft_chain.g.has.dart';

part 'shaft_chain.g.compose.dart';

@Has()
typedef ShaftList = IList<ShaftCtx>;

@Compose()
abstract class ShaftChain implements HasShaftChainList {}

ShaftChain createShaftChain({
  required MdiStateMsg stateMsg,
}) {
  final shaftChainList = stateMsg
      .getEffectiveTopShaft()
      .finiteIterable((item) => item.parentOpt)
      .toList()
      .reversed
      .map(
        (shaftMsg) => createShaftChainItem(
          appBits: appBits,
          shaftMsg: shaftMsg,
        ),
      )
      .toIList();

  final length = shaftChainList.length;
  final maxIndex = length - 1;

  shaftChainList.forEachIndexed((index, item) {
    final calc = item.shaftChainItemCalc;
    calc.shaftChainItem = item;
    calc.indexFromLeft = index;
    calc.indexFromRight = maxIndex - index;
    calc.left = index > 0 ? shaftChainList[index - 1] : null;
    calc.right = index < maxIndex ? shaftChainList[index + 1] : null;
  });

  return ComposedShaftChain(
    shaftChainList: shaftChainList,
  );
}

@Compose()
abstract class ShaftChainItem
    implements HasShaftChainItemCalc, HasShaftMsg, AppBits {}

ShaftChainItem createShaftChainItem({
  required AppBits appBits,
  required ShaftMsg shaftMsg,
}) {
  return ComposedShaftChainItem.appBits(
    appBits: appBits,
    shaftChainItemCalc: ShaftObj(),
    shaftMsg: shaftMsg,
  );
}

