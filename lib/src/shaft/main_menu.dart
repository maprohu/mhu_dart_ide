import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/shaft.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

Bx mdiMainMenuShaftBx({
  required SizedNodeBuilderBits sizedBits,
  required MdiMainMenuMsg value,
}) {
  return sizedBits.menuShaft(
    label: "Main Menu",
    items: [
      MenuItem(
        label: "build_runner",
        callback: fw(() {
          print('hello');
        }),
      ),
    ],
  );
}
