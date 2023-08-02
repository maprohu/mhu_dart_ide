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
      sizedBits.opener(
        label: "config",
        builder: (shaft) => shaft.ensureConfig(),
      ),
      MenuItem(
        label: "theme",
        callback: (() {}),
      ),
      MenuItem(
        label: "state",
        callback: (() {}),
      ),
      MenuItem(
        label: "build_runner",
        callback: (() {
          sizedBits.configBits.state.rebuild((message) {
            message.topShaft = MdiShaftMsg$.create(
              buildRunner: MdiBuildRunnerMenuMsg(),
              parent: sizedBits.shaftMsg,
            );
          });
        }),
      ),
    ],
  );
}
