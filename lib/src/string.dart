import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/widgets/boxed.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'screen.dart';

part 'string.freezed.dart';

@freezedStruct
class MonoTextStyle with _$MonoTextStyle, HasSize, HasTextStyle {
  MonoTextStyle._();

  factory MonoTextStyle({
    required Size size,
    required TextStyle textStyle,
  }) = _MonoTextStyle;

  static MonoTextStyle from(TextStyle textStyle) => MonoTextStyle(
        size: mdiTextSize("M", textStyle),
        textStyle: textStyle,
      );
}

Bx stringBx({
  required SizedNodeBuilderBits sizedBits,
  required String string,
}) {
  final style = sizedBits.themeCalc.stringTextStyle;

  final fitWidth = sizedBits.width ~/ style.width;
  final fitHeight = sizedBits.height ~/ style.height;

  final lines = string.characters
      .slices(fitWidth)
      .map((e) => e.join())
      .take(fitHeight)
      .toList();

  final lineSize = Size(
    style.width * fitWidth,
    style.height,
  );

  final lineBits = sizedBits.withSize(lineSize);

  final linesSize = Size(
    style.width * fitWidth,
    style.height * lines.length,
  );

  final linesCol = Bx.col(lines.map((line) {
    return lineBits.leaf(
      RichText(
        text: style.span(line),
      ),
    );
  }).toList());

  return Bx.pad(
    padding: Paddings.topLeft(
      outer: sizedBits.size,
      inner: linesSize,
    ),
    child: linesCol,
  );
}

mixin HasTextStyle {
  TextStyle get textStyle;
}

extension StringHasTextStyleX on HasTextStyle {
  TextSpan span(String text) => textStyle.span(text);
}

extension StringTextStyleX on TextStyle {
  TextSpan span(String text) => TextSpan(
        text: text,
        style: this,
      );
}
