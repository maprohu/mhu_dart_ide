import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/main_page.dart';
import 'package:mhu_dart_ide/src/main_screen.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'src/state.dart';

void main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  WidgetsFlutterBinding.ensureInitialized();
  mhuDartIdeLib.register();

  final disposers = DspImpl();

  final isar = await mdiCreateIsar();

  final configBits = await MdiConfigBits.create(
    isar: isar,
    disposers: disposers,
  );

  final appBits = MdiAppBits(
    isar: isar,
    configBits: configBits,
  );

  final listenable = mdiState(
    appBits: appBits,
    disposers: disposers,
  );
  runApp(
    MdiApp(
      appBits: appBits,
      listenable: listenable,
    ),
  );
}

class MdiApp extends StatelessWidget {
  final MdiAppBits appBits;

  final ValueListenable<Widget> listenable;

  MdiApp({
    super.key,
    required this.appBits,
    required this.listenable,
  });

  late final _shortcuts = {
    ...WidgetsApp.defaultShortcuts,
    for (final kh in appBits.opScreen.keyHandlers())
      SingleActivator(kh.key): VoidCallbackIntent(kh.handler)
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MHU Dart IDE",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: MdiMainScreen(listenable: listenable),
      shortcuts: _shortcuts,
    );
  }
}
