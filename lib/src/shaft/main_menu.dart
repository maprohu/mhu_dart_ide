import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

Bx mdiMainMenuShaftBx({
  required SizedNodeBuilderBits sizedBits,
  required MdiMainMenuMsg value,
}) {
  return shaftBx(
    sizedBits: sizedBits,
    header: (sizedBits) {
      return sizedBits.text(
        "Main Menu",
      );
    },
    body: (sizedBits) {
      return
    },
  );
  return sizedBits.shortcut(() {
    print('hello');
  });
}
