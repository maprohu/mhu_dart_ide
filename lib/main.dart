import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/main_page.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

void main() async {
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
  runApp(
    MdiApp(
      appBits: appBits,
    ),
  );
}

class MdiApp extends StatelessWidget {
  final MdiAppBits appBits;

  MdiApp({
    super.key,
    required this.appBits,
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
      home: mdiMainPage(
        appBits: appBits,
      ),
      shortcuts: _shortcuts,
    );
  }
}
