import 'package:mhu_dart_ide/src/bx/shaft.dart';

import '../builder/sized.dart';
import '../bx/menu.dart';
import '../bx/boxed.dart';

Bx mdiBuildRunnerMenuShaftBx({
  required SizedShaftBuilderBits sizedBits,
}) {
  return sizedBits.menuShaft(
    label: "Build Runner",
    items: [
      MenuItem(
        label: "Settings",
        callback: () {
          print('settings');
        },
      ),
    ],
  );
}
