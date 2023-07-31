import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/proto.dart';

import '../screen.dart';

Widget mdiMainMenuColumn({
  required NodeBuildBits buildBits,
  required MdiMainMenuMsg value,
}) {
  return buildBits.shortcut(() {
    print('hello');
  });
}
