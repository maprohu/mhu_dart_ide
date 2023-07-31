import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/op_shortucts.dart';
import 'package:mhu_dart_ide/src/theme.dart';

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
  required OpShortcut shortcut,
  required int pressedCount,
  required ThemeCalc themeCalc,
}) {
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
