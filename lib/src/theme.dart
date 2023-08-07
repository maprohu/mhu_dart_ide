import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';
import 'package:mhu_dart_ide/src/bx/shortcut.dart';
import 'package:mhu_dart_ide/src/bx/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

final mdiDefaultTheme = MdiThemeMsg$.create(
  dividerThickness: MdiDividerThicknessThemeMsg$.create(
    shafts: 2,
    shaftHeader: 2,
    menuItems: 1,
  ),
)..freeze();

class FontAssets {
  final robotoMono = GoogleFonts.robotoMono();
  final robotoSlab = GoogleFonts.robotoSlab();
}

class ThemeCalc {
  static Future<void> init() async {
    _fontAssets = FontAssets();
    await GoogleFonts.pendingFonts();
  }

  static late final FontAssets _fontAssets;

  static const _sizerKeys = 'MMM';
  final MdiThemeMsg theme;

  ThemeCalc(this.theme);

  late final shaftsDividerThickness = theme.dividerThicknessOpt?.shaftsOpt ?? 3;
  late final shaftHeaderDividerThickness =
      theme.dividerThicknessOpt?.shaftHeaderOpt ?? 2;
  late final menuItemsDividerThickness =
      theme.dividerThicknessOpt?.menuItems ?? 1;
  late final paginatorFooterDividerThickness =
      theme.dividerThicknessOpt?.paginatorFooterOpt ?? 2;
  late final shaftSharingDividerThickness =
      theme.dividerThicknessOpt?.shaftSharingOpt ?? 2;

  static final robotoMonoTextStyle = _fontAssets.robotoMono.copyWith(
    fontSize: 14,
    color: Colors.white,
  );

  static final robotoSlabTextStyle = _fontAssets.robotoSlab.copyWith(
    fontSize: 14,
    color: Colors.white,
  );

  late final builtinTextStyle = const TextStyle(
    fontSize: 14,
  );

  late final defaultTextStyle = robotoMonoTextStyle;

  late final shortcutTextStyle = defaultTextStyle.copyWith(
    color: Colors.yellow,
  );
  late final shortcutPressedTextStyle = defaultTextStyle.copyWith(
    color: Colors.red,
  );

  late final shaftHeaderTextStyle = defaultTextStyle;
  late final menuItemTextStyle = defaultTextStyle;

  late final shortcutSize = shortcutTextSpan(
    pressed: "",
    notPressed: _sizerKeys,
    themeCalc: this,
  ).size;

  late final shaftHeaderTextHeight =
      mdiTextSize("M", shaftHeaderTextStyle).height;

  late final shaftHeaderContentHeight =
      max(shaftHeaderTextHeight, shortcutSize.height);

  late final shaftHeaderPadding = const EdgeInsets.all(2);

  late final shaftHeaderOuterHeight =
      shaftHeaderContentHeight + shaftHeaderPadding.vertical;
  late final shaftHeaderWithDividerHeight =
      shaftHeaderOuterHeight + shaftHeaderDividerThickness;

  late final menuItemHeight = menuItemPadding.inflateSize(shortcutSize).height;

  late final menuItemPadding = const EdgeInsets.all(2);

  late final stringTextStyle = MonoTextStyle.from(robotoMonoTextStyle);

  late final paginatorFooterTextStyle = MonoTextStyle.from(robotoMonoTextStyle);

  late final paginatorFooterInnerHeight = paginatorFooterTextStyle.height;
  late final paginatorFooterOuterHeight =
      paginatorFooterInnerHeight + paginatorFooterPadding.vertical;

  late final paginatorFooterPadding = const EdgeInsets.all(2);

  late final textCursorThickness = 2;
  late final textCursorColor = Colors.red;
  late final textClipMarkerColor = Colors.red;
}

mixin HasThemeCalc {
  ThemeCalc get themeCalc;
}
