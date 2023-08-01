import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/shaft.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

Bx mdiBuildRunnerMenuShaftBx({
  required SizedNodeBuilderBits sizedBits,
  required MdiBuildRunnerMenuMsg value,
}) {
  return sizedBits.menuShaft(
    label: "Build Runner",
    items: [
      MenuItem(
        label: "Settings",
        callback: fw(() {
          print('settings');
        }),
      ),
    ],
  );
}
