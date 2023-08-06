import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:path_provider/path_provider.dart';

part 'isar.g.dart';

final _logger = Logger();

enum MdiSingleton {
  config,
  state,
  theme,
}

Future<Isar> mdiCreateIsar() async {
  final dir = await getApplicationSupportDirectory();

  _logger.w("isar dir: $dir");

  return await Isar.open(
    [SingletonRecordSchema],
    directory: dir.path,
  );
}

@collection
class MdiInnerStateRecord {
  late final Id id;

  late final List<byte> shaftMsgBytes;

  // ignore: invalid_annotation_target
  @ignore
  set shaftMsg(MdiShaftMsg shaftMsg) {
    shaftMsgBytes = shaftMsg.writeToBuffer();
    id = fastBytesHash(shaftMsgBytes);
  }

  late final List<byte> innerStateBytes;

  set innerState(MdiInnerStateMsg innerState) {
    innerStateBytes = innerState.writeToBuffer();
  }

  @ignore
  late final innerState = MdiInnerStateMsg()
    ..mergeFromBuffer(innerStateBytes)
    ..freeze();
}
