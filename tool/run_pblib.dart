
import 'package:mhu_dart_builder/mhu_dart_builder.dart';

Future<void> main() async {
  await runPbLibGenerator(
    dependencies: [
      'mhu_dart_model',
    ]
  );
}
