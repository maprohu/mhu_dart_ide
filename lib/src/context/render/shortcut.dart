part of '../render.dart';

TextSpan shortcutTextSpan({
  required String pressed,
  required String notPressed,
  required ThemeWrap themeCalc,
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

sealed class Shortcuts {
  final RenderObj renderObj;

  factory Shortcuts.fromRenderObj(RenderObj renderObj) {
    final focusedShaft = renderObj.focusedShaft;
    return focusedShaft == null
        ? ShortcutsUnfocused._(
            renderObj: renderObj,
          )
        : ShortcutsFocused._(
            renderObj: renderObj,
            focusedShaft: focusedShaft,
          );
  }

  Shortcuts._({required this.renderObj});
}

class ShortcutsUnfocused extends Shortcuts {
  ShortcutsUnfocused._({
    required super.renderObj,
  }) : super._();
}

class ShortcutsFocused extends Shortcuts {
  final ShaftCtx focusedShaft;

  ShortcutsFocused._({
    required super.renderObj,
    required this.focusedShaft,
  }) : super._();
}
