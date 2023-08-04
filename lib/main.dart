import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/theme.dart';
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
        opBuilder: OpBuilder(),
      );

      final listenable = mdiScreenListenable(
        appBits: appBits,
        disposers: disposers,
      );

      return MdiApp(
        appBits: appBits,
        listenable: listenable,
      );
    },
  );

  runApp(app);
}

class MdiApp extends StatelessWidget {
  final AppBits appBits;

  final ValueListenable<Bx> listenable;

  MdiApp({
    super.key,
    required this.appBits,
    required this.listenable,
  });

  late final _shortcuts = {
    // ...WidgetsApp.defaultShortcuts,
    for (final kh in appBits.opBuilder.allShortcutKeys)
      SingleActivator(kh.keyboardKey): VoidCallbackIntent(
        appBits.opBuilder.let(
          (opBuilder) => () => opBuilder.keyPressed(kh),
        ),
      ),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MHU Dart IDE",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: listenable,
          builder: (context, value, child) {
            final widget = value.layout();
            return widget.withKey(widget);
          },
        ),
      ),
      shortcuts: _shortcuts,
    );
  }
}
