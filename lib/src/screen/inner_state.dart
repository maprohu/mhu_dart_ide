import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../widgets/busy.dart';

// part 'inner_state.g.has.dart';
// part 'inner_state.g.compose.dart';

typedef InnerStateKey = ShaftIndexFromLeft;
typedef InnerStateFw = Fw<MdiInnerStateMsg?>;

Cache<InnerStateKey, Future<InnerStateFw>> innerStateFwCache({
  required IsarDatabase isarDatabase,
  required DspReg disposers,
}) {
  return Cache(
    (key) => isarDatabase.mdiInnerStateRecords
        .withCreateRecord(MdiInnerStateRecord.new)
        .protoRecordFwNullableWriteOnly(
          id: key,
          disposers: disposers,
        ),
  );
}

AccessInnerState createAccessInnerState({
  required IsarDatabase isarDatabase,
  required DspReg disposers,
}) {
  final cache = innerStateFwCache(
    isarDatabase: isarDatabase,
    disposers: disposers,
  );

  final taskQueue = KeyedTaskQueue<InnerStateKey>();

  return <T>(key, action) async {
    final innerStateFw = await cache.get(key);

    return taskQueue.submit(
      key,
      () => action(innerStateFw),
    );
  };
}

extension InnerStateShaftCalcBuildBitsX<T> on ShaftCalcBuildBits<T> {
  Widget innerStateWidget<S>({
    required Future<S> Function(InnerStateFw innerStateFw) access,
    required Widget Function(MdiInnerStateMsg innerState, S value) builder,
  }) {
    return futureBuilderNull(
      future: accessInnerState(
        shaftCalcChain.shaftIndexFromLeft,
        (innerStateFw) async => (innerStateFw, await access(innerStateFw)),
      ),
      builder: (context, record) {
        return flcFrr(() {
          final (innerStateFw, value) = record;

          final innerState = innerStateFw();
          if (innerState == null) {
            return mdiBusyWidget;
          }

          return builder(innerState, value);
        });
      },
    );
  }

  Widget innerStateWidgetVoid({
    void Function(InnerStateFw innerStateFw)? access,
    required Widget Function(
      MdiInnerStateMsg innerState,
      void Function(MdiInnerStateMsg? innerState) update,
    ) builder,
  }) {
    return innerStateWidget(
      access: (innerStateFw) async {
        if (access != null) {
          access(innerStateFw);
        }
        return innerStateFw.set;
      },
      builder: builder,
    );
  }
}
