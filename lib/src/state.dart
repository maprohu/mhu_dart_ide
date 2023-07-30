import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/main_screen.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

part 'state.freezed.dart';

ValueListenable<Widget> mdiState({
  required MdiAppBits appBits,
  required DspReg disposers,
}) {
  final notifier = ValueNotifier<Widget>(busyWidget);

  () async {
    final sizeFr = await ScreenSizeObserver.stream(disposers).fr(disposers);

    var state = StateInput(
      size: sizeFr.read(),
      state: appBits.state.read(),
    );

    void build() {
      notifier.value = mdiBuildScreen(
        appBits: appBits,
        state: state,
      );
    }

    void update(StateInput Function(StateInput state) updates) {
      state = updates(state);
      build();
    }

    sizeFr.changes().skip(1).forEach((size) {
      update(
        (input) => input.copyWith(
          size: size,
        ),
      );
    });
    appBits.state.changes().skip(1).forEach((state) {
      update(
        (input) => input.copyWith(
          state: state,
        ),
      );
    });

    build();
  }();

  return notifier;
}

@freezed
class StateInput with _$StateInput {
  const factory StateInput({
    required Size size,
    required MdiStateMsg state,
  }) = _StateInput;
}

final _defaultMainMenuColumn = MdiColumnMsg()..ensureMainMenu()..freeze();

Widget mdiBuildScreen({
  required MdiAppBits appBits,
  required StateInput input,
}) {
  final columnCount = input.state.columnCountOpt ?? 3;
  final opBuilder = OpBuilder();

  final columns = input.state.columnOpt.iterable.take(columnCount);

  columns.fold<ColumnsAfter?>(null, (after, column) => null)

}

extension _MdiStateMsgX on MdiColumnMsg? {
  Iterable<MdiColumnMsg> get iterable sync* {
    var c = this;
    while (c != null) {
      yield c;
      c = c.parentOpt;
    }
    yield _defaultMainMenuColumn;
  }
}

@freezedStruct
class ColumnsAfter with _$ColumnsAfter implements HasParent<ColumnsAfter> {
  ColumnsAfter._();

  factory ColumnsAfter({
    required ColumnsAfter? parent,
    required MdiColumnMsg column,
  }) = _ColumnsAfter;
}

