import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/text.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../app.dart';
import '../bx/boxed.dart';
import '../bx/padding.dart';
import '../bx/string.dart';
import '../config.dart';
import '../long_running.dart';
import '../op.dart';
import '../screen/calc.dart';
import 'double.dart';

part 'text.g.compose.dart';

@Compose()
abstract class TextBuilderBits implements HasTextStyle, SizedShaftBuilderBits {}

extension TextBuilderBitsX on TextBuilderBits {
  Bx centerLeft(String text) {
    final child = flexible(text);
    // final span = this.span(text);
    final textSize = child.size;
    return Bx.padOrFill(
      padding: Paddings.centerLeft(
        outer: size,
        inner: textSize,
      ),
      child: child,
      size: size,
    );
  }

  Bx left(String text) {
    final child = flexible(text);
    // final span = this.span(text);
    final textSize = child.size;
    return Bx.padOrFill(
      padding: Paddings.left(
        outer: width,
        inner: textSize.width,
      ),
      child: child,
      size: size.withHeight(
        textSize.height,
      ),
    );
  }

  Bx flexible(String text) {
    return flexibleTextBx(
      maxWidth: width,
      text: text,
      style: textStyle,
      splitMarker: themeCalc.defaultSplitMarker,
    );
  }

}

extension TextSizedBitsX on SizedShaftBuilderBits {
  TextBuilderBits withTextStyle(TextStyle textStyle) =>
      ComposedTextBuilderBits.sizedShaftBuilderBits(
        sizedShaftBuilderBits: this,
        textStyle: textStyle,
      );

  TextBuilderBits get headerText =>
      withTextStyle(themeCalc.shaftHeaderTextStyle);

  TextBuilderBits get itemText => withTextStyle(themeCalc.menuItemTextStyle);
}
