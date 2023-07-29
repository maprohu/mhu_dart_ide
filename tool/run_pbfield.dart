import 'package:mhu_dart_builder/mhu_dart_builder.dart';
import 'package:mhu_dart_ide/src/generated/mhu_dart_ide.pblib.dart';

void main() async {
  await runPbFieldGenerator(
    lib: mhuDartIdeLib,
  );
}
