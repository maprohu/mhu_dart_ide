import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/inner_state.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/widgets/busy.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'src/bx/screen.dart';
import 'src/bx/boxed.dart';

void main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  WidgetsFlutterBinding.ensureInitialized();
  mhuDartIdeLib.register();

  final app = flcAsyncDisposeWidget(
    waiting: nullWidget,
    builder: (disposers) async {
      await ThemeCalc.init();

      final isar = await mdiCreateIsar();

      final configBits = await ConfigBits.create(
        isar: isar,
        disposers: disposers,
      );

      final screenSizeFr =
          await ScreenSizeObserver.stream(disposers).fr(disposers);

      final appBits = ComposedAppBits.configBits(
        configBits: configBits,
        screenSizeFr: screenSizeFr,
        opBuilder: OpBuilder(configBits),
        accessInnerState: createAccessInnerState(
          isarDatabase: isar,
          disposers: disposers,
        ),
      );

      final screenStreamController = StreamController<Bx>();

      final app = MdiApp(
        appBits: appBits,
        listenable: screenStreamController.stream,
      );

      mdiStartScreenStream(
        appBits: appBits,
        disposers: disposers,
        screenStream: screenStreamController,
      );

      return app;
    },
  );

  runApp(app);
}

class MdiApp extends StatelessWidget {
  final AppBits appBits;

  final Stream<Bx> listenable;

  MdiApp({
    super.key,
    required this.appBits,
    required this.listenable,
  });

  late final _shortcuts = {
    // ...WidgetsApp.defaultShortcuts,
  };

  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: appBits.opBuilder.onKeyEvent,
      child: MaterialApp(
        title: "MHU Dart IDE",
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          body: streamBuilder(
            stream: listenable,
            busy: (context) => mdiBusyWidget,
            builder: (context, value) {
              return value.layout().let((e) => e.withKey(e));
            },
          ),
        ),
        shortcuts: const {},
      ),
    );
  }
}
