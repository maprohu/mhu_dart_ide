import 'dart:async';

import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/proto/field/map_entry.dart';

import '../keyboard.dart';
import '../long_running.dart';

part 'confirm.g.compose.dart';

@Compose()
abstract class ConfirmShaftMerge
    implements ShaftLabeledContentBits, HasOnShaftOpen {}

@Compose()
abstract class ConfirmShaft
    implements ShaftCalcBuildBits, ConfirmShaftMerge, ShaftCalc {
  static ConfirmShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final confirmType =
        shaftCalcBuildBits.shaftMsg.shaftIdentifier.confirm.type;

    final merge = switch (confirmType) {
      MdiConfirmMsg_Type$deleteEntry() => ComposedConfirmShaftMerge(
          shaftHeaderLabel: "Delete Entry",
          buildShaftContent: (sizedBits) {
            return [
              stringVerticalSharingBx(
                sizedBits: sizedBits,
                string: "Confirm delete (Enter) or Cancel (Escape)?",
              ),
            ];
          },
          onShaftOpen: () {
            final opBuilder = shaftCalcBuildBits.opBuilder;

            final hasDeleteEntry =
                shaftCalcBuildBits.leftSignificantCalc as HasDeleteEntry;

            opBuilder.startAsyncOp(
              shaftIndexFromLeft: shaftCalcBuildBits.shaftIndexFromLeft,
              start: (addShortcutKeyListener) async {
                final completer = Completer();

                addShortcutKeyListener(
                  (key) {
                    switch (key) {
                      case ShortcutKey.escape:
                        shaftCalcBuildBits.closeShaft();
                        completer.complete();
                      case ShortcutKey.enter:
                        hasDeleteEntry.deleteEntry();
                        completer.complete();
                      default:
                    }
                  },
                );

                await completer.future;
              },
            );
          },
        ),
      _ => throw confirmType,
    };

    return ComposedConfirmShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      confirmShaftMerge: merge,
    );
  }
}
