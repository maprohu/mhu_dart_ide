import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'src/widgets/boxed.dart';

void main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  WidgetsFlutterBinding.ensureInitialized();
  mhuDartIdeLib.register();

  final app = flcAsyncDisposeWidget(
    waiting: nullWidget,
    builder: (disposers) async {
      final isar = await mdiCreateIsar();

      final configBits = await MdiConfigBits.create(
        isar: isar,
        disposers: disposers,
      );

      final screenSize =
          await ScreenSizeObserver.stream(disposers).fr(disposers);

      final appBits = MdiAppBits(
        isar: isar,
        configBits: configBits,
        screenSize: screenSize,
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
  final MdiAppBits appBits;

  final ValueListenable<Bx> listenable;

  MdiApp({
    super.key,
    required this.appBits,
    required this.listenable,
  });

  late final _shortcuts = {
    ...WidgetsApp.defaultShortcuts,
    for (final kh in appBits.opScreen.allShortcutKeys)
      SingleActivator(kh.keyboardKey): VoidCallbackIntent(
        appBits.opScreen.let(
          (scr) => () => scr.keyPressed(kh),
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
            return StretchWidget(
              child: value.layout(),
            );
          },
        ),
      ),
      shortcuts: _shortcuts,
    );
  }
}
