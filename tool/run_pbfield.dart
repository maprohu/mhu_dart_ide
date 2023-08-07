import 'package:mhu_dart_ide/src/generated/mhu_dart_ide.pblib.dart';
import 'package:mhu_dart_pbgen/mhu_dart_pbgen.dart';

void main() async {
  await runPbFieldGenerator(
    lib: mhuDartIdeLib,
  );
}
