import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/menu_dynamic.dart';
import 'package:mhu_dart_ide/src/bx/text.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/sharing_box.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'bx/boxed.dart';

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
  ShaftBuilderBits shaftBuilderBits,
);

@Has()
typedef AddLongRunningTask = void Function(
  LongRunningTaskBuildBits Function(
    LongRunningTaskIdentifier taskIdentifier,
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

@Has()
typedef BuildLongTermCompleteView<T> = SharingBoxes Function(
  SizedShaftBuilderBits sizedShaftBuilderBits,
  T value,
);

@Compose()
abstract class LongTermBusy implements HasBuildShaftContent, HasWatchLabel {}

@Has()
typedef WatchLongTermCompleteLabel<T> = Label Function(T value);

@Compose()
abstract class LongTermComplete<T>
    implements
        HasBuildLongTermCompleteView<T>,
        HasWatchLongTermCompleteLabel<T> {}

@Compose()
abstract class LongRunningTaskBuildBits implements HasLongRunningTaskMenuItem {
  static LongRunningTaskBuildBits create<T extends Object>({
    required LongRunningTaskIdentifier taskIdentifier,
    required Future<T> future,
    required LongTermBusy longTermBusy,
    required LongTermComplete<T> longTermComplete,
  }) {
    return ComposedLongRunningTaskBuildBits(
      longRunningTaskMenuItem: (shaftBuilderBits) {
        final themeCalc = shaftBuilderBits.themeCalc;
        final openerBits = ShaftTypes.viewTask.openerBits(
          shaftBuilderBits,
          shaftKey: (key) => key.taskIdentifier = taskIdentifier,
        );
        return DynamicMenuItem.direct(
          labelBuilder: (size) {
            Widget widget({
              required WatchLabel watchLabel,
              required Widget statusIcon,
            }) =>
                Row(
                  children: [
                    Flexible(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;

                          return flcFrr(() {
                            return flexibleTextBx(
                              maxWidth: maxWidth,
                              text: watchLabel(),
                              style: themeCalc.menuItemTextStyle,
                              splitMarker: themeCalc.defaultSplitMarker,
                            ).layout();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.height,
                      height: size.height,
                      child: statusIcon,
                    ),
                  ],
                );
            return Bx.leaf(
              size: size,
              widget: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width,
                ),
                child: futureBuilder(
                  future: future,
                  busy: (context) {
                    return widget(
                      watchLabel: longTermBusy.watchLabel,
                      statusIcon: const CircularProgressIndicator(),
                    );
                  },
                  builder: (context, value) {
                    return widget(
                      watchLabel: () =>
                          longTermComplete.watchLongTermCompleteLabel(value),
                      statusIcon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ).withKey(value);
                  },
                ),
              ),
            );
          },
          opCallback: openerBits.shortcutCallback,
          openerState: openerBits.openerState,
        );
      },
    );
  }
}

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
