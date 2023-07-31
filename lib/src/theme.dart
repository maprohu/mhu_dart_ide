import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/widgets/shortcut.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';

final mdiDefaultTheme = MdiThemeMsg$.create()..freeze();

class ThemeCalc {
  static const _sizerKeys = 'MM';
  final MdiThemeMsg theme;

  ThemeCalc(this.theme);

  late final mainColumnsDividerThickness = theme.dividerThickness.mainColumns;

  late final monoTextStyle = GoogleFonts.robotoMono().copyWith(
    fontSize: 14,
    color: Colors.white,
  );

  late final builtinTextStyle = const TextStyle(
    fontSize: 14,
  );

  late final robotoSlabTextStyle = GoogleFonts.robotoSlab().copyWith(
    fontSize: 14,
    color: Colors.white,
  );

  late final shortcutTextStyle = robotoSlabTextStyle.copyWith(
    color: Colors.yellow,
  );
  late final shortcutPressedTextStyle = robotoSlabTextStyle.copyWith(
    color: Colors.red,
  );

  late final shortcutSize = shortcutTextSpan(
    pressed: "",
    notPressed: _sizerKeys,
    themeCalc: this,
  ).size;
}
