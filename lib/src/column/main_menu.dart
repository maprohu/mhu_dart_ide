import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/proto.dart';

import '../screen.dart';
import '../widgets/boxed.dart';

Bx mdiMainMenuColumn({
  required SizedNodeBuilderBits buildBits,
  required MdiMainMenuMsg value,
}) {
  return buildBits.shortcut(() {
    print('hello');
  });
}
