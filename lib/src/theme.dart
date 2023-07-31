import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/column.dart';
import 'package:mhu_dart_ide/src/icons.dart';
import 'package:mhu_dart_ide/src/widgets/shortcut.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';

final mdiDefaultTheme = MdiThemeMsg$.create(
  dividerThickness: MdiDividerThicknessThemeMsg$.create(
    mainColumns: 2,
    columnHeader: 2,
    columnItems: 1,
  ),
)..freeze();

class ThemeCalc {
  static const _sizerKeys = 'MM';
  final MdiThemeMsg theme;

  ThemeCalc(this.theme);

  late final mainColumnsDividerThickness = theme.dividerThickness.mainColumns;
  late final columnHeaderDividerThickness = theme.dividerThickness.columnHeader;
  late final columnItemsDividerThickness = theme.dividerThickness.columnItems;

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

  late final columnHeaderContentHeight = sizedIconWidget(
    themeCalc: this,
    icon: MdiIcons.help,
    shortcutData: null,
  ).height;

  late final columnHeaderPadding = const EdgeInsets.all(2);
}
