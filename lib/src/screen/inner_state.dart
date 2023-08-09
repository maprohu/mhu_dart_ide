import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

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
