import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/boxed.dart';
import 'package:mhu_dart_ide/src/bx/text.dart';
import 'package:mhu_dart_ide/src/context/app.dart';
import 'package:mhu_dart_ide/src/context/rect.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../proto.dart';
import '../bx/padding.dart';
import '../bx/shortcut.dart';
import '../bx/string.dart';
import '../wx/wx.dart';
import 'text.dart';
import 'theme.dart' as $lib;

part 'theme.g.dart';

part 'theme.g.has.dart';

@Has()
typedef ThemeMsg = MdiThemeMsg;

final mdiDefaultTheme = MdiThemeMsg$.create(
  dividerThickness: MdiDividerThicknessThemeMsg$.create(
    shafts: 2,
    shaftHeader: 2,
    menuItems: 1,
  ),
)..freeze();

@Compose()
abstract base class ThemeWrap implements HasDataCtx, HasThemeMsg {
  static const _sizerKeys = 'MMM';

  late final assetObj = dataCtx.assetObj;

  late final minShaftWidthPixels = themeMsg.minShaftWidthOpt ?? 200.0;

  late final shaftsDividerThickness =
      themeMsg.dividerThicknessOpt?.shaftsOpt ?? 3;
  late final shaftHeaderDividerThickness =
      themeMsg.dividerThicknessOpt?.shaftHeaderOpt ?? 2;
  late final menuItemsDividerThickness =
      themeMsg.dividerThicknessOpt?.menuItems ?? 1;
  late final paginatorFooterDividerThickness =
      themeMsg.dividerThicknessOpt?.paginatorFooterOpt ?? 2;
  late final shaftSharingDividerThickness =
      themeMsg.dividerThicknessOpt?.shaftSharingOpt ?? 2;

  late final shaftBackgroundColor = grayscale(3 / 16);
  late final dividerColor = grayscale(5 / 16);

  late final robotoMonoTextStyle = assetObj.robotoMonoFont.copyWith(
    fontSize: 14,
    color: Colors.white,
  );

  late final robotoSlabTextStyle = assetObj.robotoSlabFont.copyWith(
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
  late final splitMarkerTextStyle = defaultTextStyle.copyWith(
    color: Colors.red,
  );

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

  late final menuItemInnerHeight = shortcutSize.height;

  late final menuItemHeight = menuItemPadding.vertical + menuItemInnerHeight;

  late final menuItemPadding = const EdgeInsets.all(2);

  late final stringTextStyle = MonoTextStyle.from(robotoMonoTextStyle);

  late final paginatorFooterTextStyle = MonoTextStyle.from(robotoMonoTextStyle);

  late final paginatorFooterInnerHeight = paginatorFooterTextStyle.height;
  late final paginatorFooterOuterHeight =
      paginatorFooterInnerHeight + paginatorFooterPadding.vertical;

  late final paginatorFooterPadding = const EdgeInsets.all(2);

  late final textCursorThickness = 2.0;
  late final textCursorColor = Colors.red;
  late final textClipMarkerColor = Colors.red;

  late final notificationTextStyle = robotoSlabTextStyle;

  static Color grayscale(double value) {
    final rgb = (value * 255).round();
    return Color.fromARGB(255, rgb, rgb, rgb);
  }

  late final openItemColor = grayscale(0.5);

  late final longRunningTaskCompleteNotificationColor = Colors.green;
  late final longRunningTaskCompleteIconData = Icons.notification_important;

  late final textSplitMarker = this.themeTextSplitMarkBuilder();
}

ThemeWrap createThemeWrap({
  @Ext() required DataCtx dataCtx,
  required ThemeMsg themeMsg,
}) {
  final themeObj = ComposedThemeWrap(
    dataCtx: dataCtx,
    themeMsg: themeMsg,
  );
  return themeObj;
}

WxHeightBuilder themeTextSplitMarkBuilder({
  @ext required ThemeWrap themeWrap,
}) {
  final textSpan = themeWrap.splitMarkerTextStyle.createTextSpan("?");
  final size = textSpan.size;
  final widget = RichText(
    text: textSpan,
  );
  final child = createWx(
    size: size,
    widget: widget,
  );

  return (height) {
    return wxAlignAxis(
      size: size,
      wx: child,
      axis: Axis.vertical,
      axisAlignment: AxisAlignment.center,
    );
  };
}
