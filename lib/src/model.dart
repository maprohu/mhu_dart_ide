import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

extension MdiShaftMsgX on MdiShaftMsg {
  Iterable<MdiShaftMsg> get iterableTowardsLeft =>
      finiteIterable((e) => e.parentOpt);

  MdiShaftMsg? shaftByIndexFromLeft(int index) {
    final listTowardsLeft = iterableTowardsLeft.toList();
    final reverseIndex = listTowardsLeft.length - index - 1;
    return listTowardsLeft.getOrNull(reverseIndex);
  }

  void clearNotificationsDeepMutate() {
    for (final msg in iterableTowardsLeft) {
      msg.notifications.clear();
    }
  }

  MdiShaftMsg clearNotificationsDeepRebuild() {
    return deepRebuild((msg) {
      msg.clearNotificationsDeepMutate();
    });
  }
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
