import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

extension NotificationHasShaftCalcChainX on HasShaftCalcChain {
  void showNotification(String message) {
    showNotifications(message.toSingleElementIterable);
  }

  void showNotifications(Iterable<String> messages) {
    shaftCalcChain.shaftMsgFu.update((shaftMsg) {
      final notifications = shaftMsg.notifications;
      notifications.clear();

      messages
          .map((message) => MdiNotificationMsg()..text = message)
          .let(notifications.addAll);
    });
  }
}
