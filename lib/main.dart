import 'dart:math';
import 'dart:ui';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/long_running.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'src/bx/divider.dart';
import 'src/bx/screen.dart';
import 'src/bx/boxed.dart';
import 'src/dart/dart_package.dart';
import 'src/screen/app.dart';

void main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  WidgetsFlutterBinding.ensureInitialized();
  mhuDartIdeLib.register();

  final app = flcAsyncDisposeWidget(
    waiting: nullWidget,
    builder: (disposers) async {
      await ThemeCalc.init();

      final isar = await mdiCreateIsar();

      late final UpdateView updateView;

      final configBits = await ConfigBits.create(
        isar: isar,
        disposers: disposers,
        updateView: (update) {
          updateView(update);
        },
      );

      final screenSizeFr =
          await ScreenSizeObserver.stream(disposers).fr(disposers);

      final opBuilder = OpBuilder(configBits);

      final longRunningTasksController = LongRunningTasksController.create(
        configBits: configBits,
      );
      

      final appBits = ComposedAppBits.merge$(
        configBits: configBits,
        dartPackagesBits: DartPackagesBits.create(),
        screenSizeFr: screenSizeFr,
        opBuilder: opBuilder,
        longRunningTasksController: longRunningTasksController,
        shaftDataStore: {},
      );

      final Fw<BeforeAfter<ShaftsLayout>> shaftsLayoutFw = fw(
        (
          before: ShaftsLayout.initial,
          after: ShaftsLayout.initial,
        ),
      );

      final app = MdiApp(
        appBits: appBits,
        shaftsLayout: shaftsLayoutFw.watch,
      );

      updateView = mdiStartScreenStream(
        appBits: appBits,
        disposers: disposers,
        shaftsLayout: (value) {
          shaftsLayoutFw.value = (
            before: shaftsLayoutFw.read().after,
            after: value,
          );
        },
      );

      return app;
    },
  );

  runApp(app);
}
