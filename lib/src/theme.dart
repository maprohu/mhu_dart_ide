import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/icons.dart';
import 'package:mhu_dart_ide/src/op_shortucts.dart';
import 'package:mhu_dart_ide/src/widgets/shortcut.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';

final mdiDefaultTheme = MdiThemeMsg$.create(
  dividerThickness: MdiDividerThicknessThemeMsg$.create(
    shafts: 2,
    shaftHeader: 2,
    shaftItems: 1,
  ),
)..freeze();

class ThemeCalc {
  static const _sizerKeys = 'MM';
  final MdiThemeMsg theme;

  ThemeCalc(this.theme);

  late final shaftsDividerThickness = theme.dividerThickness.shafts;
  late final shaftHeaderDividerThickness = theme.dividerThickness.shaftHeader;
  late final shaftItemsDividerThickness = theme.dividerThickness.shaftItems;

  late final robotoMonoTextStyle = GoogleFonts.robotoMono().copyWith(
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

  late final defaultTextStyle = robotoMonoTextStyle;

  late final shortcutTextStyle = defaultTextStyle.copyWith(
    color: Colors.yellow,
  );
  late final shortcutPressedTextStyle = defaultTextStyle.copyWith(
    color: Colors.red,
  );

  late final shortcutSize = shortcutTextSpan(
    pressed: "",
    notPressed: _sizerKeys,
    themeCalc: this,
  ).size;

  late final shaftHeaderContentHeight = shortcutWithIconBx(
    themeCalc: this,
    icon: MdiIcons.help,
    shortcutData: ShortcutData(
      shortcut: [
        ShortcutKey.of(LogicalKeyboardKey.keyM),
        ShortcutKey.of(LogicalKeyboardKey.keyM),
      ].toIList(),
      pressedCount: 1,
    ),
  ).height;

  late final shaftHeaderPadding = const EdgeInsets.all(2);

  late final shortcutIconDimension = 12.0;
  late final shortcutIconSize = Size.square(shortcutIconDimension);
  late final shortcutIconGap = 1.0;
}
