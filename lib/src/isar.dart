import 'dart:async';

import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:path_provider/path_provider.dart';

// part 'isar.g.dart';

final _logger = Logger();

enum MdiSingleton {
  config,
  state,
  theme,
  notifications,
}

Future<Isar> mdiCreateIsar() async {
  final dir = await getApplicationSupportDirectory();

  _logger.i("isar dir: $dir");

  return await Isar.open(
    [
      SingletonRecordSchema,
      // MdiInnerStateRecordSchema,
    ],
    directory: dir.path,
  );
}

// @collection
// class MdiInnerStateRecord
//     with BlobRecord, IsarIdRecord, ProtoRecord<MdiInnerStateMsg> {
//   @override
//   MdiInnerStateMsg createProto$() => MdiInnerStateMsg();
// }

