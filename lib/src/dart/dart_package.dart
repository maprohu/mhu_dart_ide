import 'dart:io';
import 'package:path/path.dart' as p;

const packageYamlName = "package.yaml";

Stream<String> scanForDartPackages({
  required String directoryPath,
}) async* {
  final skip = <Directory>{};

  Stream<String> scan(Directory directory) async* {
    final currentPath = directory.path;
    directory = directory.absolute;
    if (!skip.add(directory)) {
      return;
    }

    await for (final entity in directory.list()) {
      switch (entity) {
        case File(:final path):
          if (p.basename(path) == packageYamlName) {
            yield currentPath;
          }
        case Directory(:final path):
          final baseName = p.basename(path);
          if (!baseName.startsWith('.')) {
            yield* scan(entity);
          }
      }
    }
  }

  yield* scan(
    Directory(directoryPath),
  );
}
