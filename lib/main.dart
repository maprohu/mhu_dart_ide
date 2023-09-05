import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/isar.dart';
import 'package:mhu_dart_model/mhu_dart_model.dart';
import 'package:mhu_dart_pbschema/mhu_dart_pbschema.dart';
import 'package:mhu_shafts/mhu_shafts.dart';
import 'package:protobuf/protobuf.dart';

import 'main.dart' as $lib;
import 'proto.dart';

part 'main.g.has.dart';

part 'main.g.dart';

// part 'main.freezed.dart';

part 'main_menu.dart';

part 'custom_shafts.dart';

part 'proto_shaft.dart';

part 'config.dart';

part 'data.dart';

void main() async {
  initMhuShafts();

  final app = ComposedMhuShaftsConfig(
    isarSchemas: [
      MdiSingletonRecordSchema,
    ],
    buildConfigObj: createSampleConfigObj,
    buildCustomShaftActions: mdiCustomShaftActions,
    buildMainMenuShaftActions: sampleMainMenu,
  ).mhuShaftsApp();

  runApp(app);
}
