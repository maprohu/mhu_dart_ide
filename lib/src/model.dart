import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

import 'app.dart';
import 'context/shaft.dart';
import 'model.dart' as $lib;
import 'shaft/main_menu.dart';
import 'shaft_factory.dart';

part 'model.g.has.dart';

part 'model.g.dart';

typedef ShaftWidthUnit = int;

@Has()
typedef WindowStateMsg = MdiWindowStateMsg;

@Has()
typedef ShaftMsg = MdiShaftMsg;

extension MdiShaftMsgX on MdiShaftMsg {
  Iterable<MdiShaftMsg> get iterableTowardsLeft =>
      finiteIterable((e) => e.parentOpt);

  MdiShaftMsg? shaftByIndexFromLeft(int index) {
    final listTowardsLeft = iterableTowardsLeft.toList();
    final reverseIndex = listTowardsLeft.length - index - 1;
    return listTowardsLeft.getOrNull(reverseIndex);
  }

// void clearNotificationsDeepMutate() {
//   for (final msg in iterableTowardsLeft) {
//     msg.notifications.clear();
//   }
// }
//
// MdiShaftMsg clearNotificationsDeepRebuild() {
//   return deepRebuild((msg) {
//     msg.clearNotificationsDeepMutate();
//   });
// }
}

extension PfeMapKeyDataTypeX<K> on MapKeyDataType<K> {
  ScalarAttribute<MdiMapEntryKeyMsg, K> get mapEntryKeyMsgAttribute {
    final MapKeyDataType self = this;
    final ScalarAttribute<MdiMapEntryKeyMsg, dynamic> result = switch (self) {
      StringDataType() => MdiMapEntryKeyMsg$.stringKey.hack,
      CoreIntDataType() => MdiMapEntryKeyMsg$.intKey.hack,
      final other => throw other,
    };

    return result as ScalarAttribute<MdiMapEntryKeyMsg, K>;
  }
}

extension _Hack on ScalarAttribute<MdiMapEntryKeyMsg, dynamic> {
  ScalarAttribute<MdiMapEntryKeyMsg, dynamic> get hack => this;
}

ShaftMsg getEffectiveTopShaft({
  @Ext() required MdiWindowStateMsg stateMsg,
}) {
  return stateMsg.topShaftOpt ?? createDefaultShaftMsg();
}

ShaftMsg createDefaultShaftMsg() {
  return MdiShaftMsg()
    ..ensureShaftMsgMainMenu()
    ..freeze();
}

void ensureShaftMsgMainMenu({
  @Ext() required ShaftMsg shaftMsg,
}) {
  shaftMsg.ensureShaftIdentifier().shaftFactoryKey = shaftFactories
      .lookupSingletonByType<MainMenuShaftFactory>()
      .getShaftFactoryKey();
}

ShaftMsg ensureEffectiveTopShaft({
  required MdiWindowStateMsg stateMsg,
}) {
  return stateMsg.topShaftOpt ??
      (stateMsg.ensureTopShaft()..ensureShaftMsgMainMenu());
}

ShaftWidthUnit getShaftEffectiveWidthUnits({
  @extHas required ShaftMsg shaftMsg,
}) {
  return shaftMsg.widthUnitsOpt ?? 1;
}
