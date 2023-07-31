import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:path_provider/path_provider.dart';

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
