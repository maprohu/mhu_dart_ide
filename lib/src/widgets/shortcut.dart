import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/op_shortucts.dart';
import 'package:mhu_dart_ide/src/theme.dart';

import 'boxed.dart';

part 'shortcut.freezed.dart';

TextSpan shortcutTextSpan({
  required String pressed,
  required String notPressed,
  required ThemeCalc themeCalc,
}) {
  return TextSpan(
    children: [
      TextSpan(
        text: pressed,
        style: themeCalc.shortcutPressedTextStyle,
      ),
      TextSpan(
        text: notPressed,
        style: themeCalc.shortcutTextStyle,
      ),
    ],
  );
}

Widget shortcutWidget({
  required ShortcutData data,
  required ThemeCalc themeCalc,
}) {
  final ShortcutData(
    :shortcut,
    :pressedCount,
  ) = data;
  String str(Iterable<ShortcutKey> sc) => sc.map((e) => e.display).join();
  return RichText(
    textAlign: TextAlign.center,
    softWrap: false,
    overflow: TextOverflow.visible,
    maxLines: 1,
    text: shortcutTextSpan(
      pressed: str(shortcut.take(pressedCount)),
      notPressed: str(shortcut.skip(pressedCount)),
      themeCalc: themeCalc,
    ),
  );
}

Bx shortcutBx({
  required ShortcutData? data,
  required ThemeCalc themeCalc,
}) {
  Widget? child;

  if (data != null) {
    child = shortcutWidget(
      data: data,
      themeCalc: themeCalc,
    );
  }

  final size = themeCalc.shortcutSize;

  return Bx.leaf(
    size: size,
    widget: child,
  );
}

@freezed
class ShortcutData with _$ShortcutData {
  const factory ShortcutData({
    required OpShortcut shortcut,
    required int pressedCount,
  }) = _ShortcutData;
}

Bx shortcutWithIconBx({
  required ThemeCalc themeCalc,
  required Widget icon,
  required ShortcutData? shortcutData,
}) {
  return Bx.colCentered([
    iconBx(
      icon: icon,
      themeCalc: themeCalc,
    ),
    Bx.fillWith(height: themeCalc.shortcutIconGap),
    shortcutBx(
      data: shortcutData,
      themeCalc: themeCalc,
    ),
  ]);
}

Bx iconBx({
  required Widget icon,
  required ThemeCalc themeCalc,
}) {
  return Bx.leaf(
    size: themeCalc.shortcutIconSize,
    widget: icon,
  );
}
