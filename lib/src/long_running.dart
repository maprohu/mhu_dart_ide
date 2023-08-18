import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/menu_dynamic.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

part 'long_running.g.has.dart';

part 'long_running.g.compose.dart';

// @Has()
// typedef ShowLongRunningResult = VoidCallback;

@Has()
typedef LongRunningTaskIdentifier = int;

// @Has()
// typedef LongRunningValue = ReadWatchValue<LongRunningState>;

@Has()
typedef LongRunningTasks = ReadWatchValue<IList<LongRunningTask>>;

@Has()
typedef LongRunningTaskMenuItem = DynamicMenuItem Function(
  ShaftCalcBuildBits shaftCalcBuildBits,
);

@Has()
typedef AddLongRunningTask = void Function(
  LongRunningTaskBuildBits Function(
    LongRunningTaskIdentifier identifier,
  ) builder,
);

@Has()
typedef RemoveLongRunningTask = void Function(
  LongRunningTaskIdentifier identifier,
);

// sealed class LongRunningState {}
//
// @Compose()
// abstract class LongRunningBusy implements LongRunningState, HasLabelBuilder {}
//
// @Compose()
// abstract class LongRunningComplete
//     implements LongRunningState, HasLabelBuilder, HasShowLongRunningResult {}

@Compose()
abstract class LongRunningTaskBuildBits implements HasLongRunningTaskMenuItem {}

@Compose()
abstract class LongRunningTask
    implements LongRunningTaskBuildBits, HasLongRunningTaskIdentifier {}

@Compose()
@Has()
abstract class LongRunningTasksController
    implements
        HasLongRunningTasks,
        HasAddLongRunningTask,
        HasRemoveLongRunningTask {
  static LongRunningTasksController create({
    required ConfigBits configBits,
  }) {
    final tasksValue = fw(IList<LongRunningTask>());

    final identifierSequence = configBits.sequencesFw.longRunningTaskId;

    return ComposedLongRunningTasksController(
      longRunningTasks: tasksValue.toReadWatchValue,
      addLongRunningTask: (builder) {
        final taskId = identifierSequence.value;
        identifierSequence.update((v) => v + 1);

        final taskBits = builder(taskId);

        final task = ComposedLongRunningTask.longRunningTaskBuildBits(
          longRunningTaskBuildBits: taskBits,
          longRunningTaskIdentifier: taskId,
        );

        tasksValue.update(
          (v) => v.add(task),
        );
      },
      removeLongRunningTask: (identifier) {
        tasksValue.update(
          (v) => v.removeWhere(
            (element) => element.longRunningTaskIdentifier == identifier,
          ),
        );
      },
    );
  }
}
