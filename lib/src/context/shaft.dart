import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/screen.dart';
import 'package:mhu_dart_ide/src/context/render.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
export 'package:mhu_dart_ide/src/context/render.dart';

import '../../proto.dart';
import 'shaft.dart' as $lib;

part 'shaft.g.dart';

part 'shaft.g.has.dart';

part 'shaft.g.compose.dart';

@Has()
class ShaftObj with MixShaftCtx, MixShaftMsg {
  late final ShaftCtx? left;
  late final ShaftCtx? right;
  late final int indexFromLeft;
  late final int indexFromRight;
}

@Compose()
@Has()
abstract class ShaftCtx implements RenderCtx, HasShaftObj {}

ShaftCtx createShaftCtx({
  @Ext() required RenderCtx renderCtx,
  required ShaftMsg shaftMsg,
}) {
  final shaftObj = ShaftObj().also(shaftMsg.initMixShaftMsg);

  return ComposedShaftCtx.renderCtx(
    renderCtx: renderCtx,
    shaftObj: shaftObj,
  )..initMixShaftCtx(shaftObj);
}

typedef ShaftList = IList<ShaftCtx>;

ShaftList createShaftList({
  @Ext() required RenderCtx renderCtx,
}) {
  final shaftChainList = renderCtx
      .getRenderStateMsg()
      .getEffectiveTopShaft()
      .finiteIterable((item) => item.parentOpt)
      .toList()
      .reversed
      .map(
        (shaftMsg) => renderCtx.createShaftCtx(shaftMsg: shaftMsg),
      )
      .toIList();

  final length = shaftChainList.length;
  final maxIndex = length - 1;

  shaftChainList.forEachIndexed((index, item) {
    final calc = item.shaftObj;
    calc.indexFromLeft = index;
    calc.indexFromRight = maxIndex - index;
    calc.left = index > 0 ? shaftChainList[index - 1] : null;
    calc.right = index < maxIndex ? shaftChainList[index + 1] : null;
  });

  return shaftChainList;
}
// Fu<MdiShaftMsg> shaftMsgFuByIndex({
//   required ConfigCtx configCtx,
//   required ShaftIndexFromLeft shaftIndexFromLeft,
// }) {
//   return Fu.fromFr(
//     fr: configCtx.stateFw.map((state) {
//       return state.effectiveTopShaft
//           .getShaftByIndexFromLeft(shaftIndexFromLeft);
//     }),
//     update: (updates) {
//       configCtx.stateFw.deepRebuild((state) {
//         state
//             .ensureEffectiveTopShaft()
//             .getShaftByIndexFromLeft(shaftIndexFromLeft)
//             .let(updates);
//       });
//     },
//   );
// }
