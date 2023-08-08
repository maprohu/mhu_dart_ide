import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:protobuf/protobuf.dart';

extension MdiShaftMsgX on MdiShaftMsg {
  Iterable<MdiShaftMsg> get iterableTowardsLeft => finiteIterable((e) => e.parentOpt);
  MdiShaftMsg shaftByIndexFromLeft(int index) {
    final listTowardsLeft = iterableTowardsLeft.toList();
    return listTowardsLeft[listTowardsLeft.length - index - 1];
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
