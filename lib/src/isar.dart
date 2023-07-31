import 'package:isar/isar.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:path_provider/path_provider.dart';


enum MdiSingleton {
  config,
  state,
  theme,
}
Future<Isar> mdiCreateIsar() async {
  final dir = await getApplicationDocumentsDirectory();

  return await Isar.open(
    [SingletonRecordSchema],
    directory: dir.path,
  );
}
