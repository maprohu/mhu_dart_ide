import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/keyboard.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../proto.dart';
import '../builder/shaft.dart';
import 'boxed.dart';

typedef ShortcutCallback = VoidCallback;

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
  String str(Iterable<CharacterShortcutKey> sc) =>
      sc.map((e) => e.character).join();
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
  Bx openerFieldShortcut(
    ScalarFieldAccess<MdiShaftMsg, dynamic> access,
  ) {
    return shortcut(
      openerCallback(
        (shaft) {
          access.set(shaft, access.defaultSingleValue);
        },
      ),
      backgroundColor: openerFieldBackgroundColor(access),
    );
  }

  Bx shortcut(
    VoidCallback callback, {
    Color? backgroundColor,
  }) {
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
      backgroundColor: backgroundColor,
    );
  }
}
