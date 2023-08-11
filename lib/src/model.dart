import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:protobuf/protobuf.dart';

extension MdiShaftMsgX on MdiShaftMsg {
  Iterable<MdiShaftMsg> get iterableTowardsLeft => finiteIterable((e) => e.parentOpt);
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
