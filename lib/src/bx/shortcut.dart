import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/keyboard.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../builder/shaft.dart';
import 'boxed.dart';

part 'shortcut.freezed.dart';

typedef ShortcutCallback = VoidCallback;

@freezed
class ShortcutData with _$ShortcutData {
  const factory ShortcutData({
    required OpShortcut shortcut,
    required int pressedCount,
  }) = _ShortcutData;
}

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



extension NodeBuildBitxX on ShaftBuilderBits {
  Bx shortcut(VoidCallback callback) {
    final handle = opBuilder.register(callback);

    return Bx.leaf(
      size: themeCalc.shortcutSize,
      widget: flcFrr(() {
        ShortcutData? data;
        final pressedCount = handle.watchState();
        if (pressedCount != null) {
          data = ShortcutData(
            shortcut: handle.shortcut(),
            pressedCount: pressedCount,
          );
        }
        return shortcutBx(
          data: data,
          themeCalc: themeCalc,
        ).layout();
      }),
    );
  }
}
