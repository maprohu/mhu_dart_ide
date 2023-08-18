import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

BuildShaftContent? longRunningTasksShaftContent({
  required AppBits appBits,
}) {
  final AppBits(
    :longRunningTasksController,
  ) = appBits;

  final runningTasks = longRunningTasksController.longRunningTasks.watchValue();

  if (runningTasks.isEmpty) {
    return null;
  }

  return (sizedBits) {
    return sizedBits.dynamicMenu([
      ...runningTasks.map(
        (task) => task.longRunningTaskMenuItem(sizedBits),
      ),
    ]).toSingleElementIterable;
  };
}
