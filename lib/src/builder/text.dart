

import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../bx/boxed.dart';
import '../bx/padding.dart';
import '../bx/string.dart';

part 'text.freezed.dart';

@freezedStruct
class TextBuilderBits
    with _$TextBuilderBits, HasTextStyle, HasSizedBits, HasSize {
  TextBuilderBits._();

  factory TextBuilderBits({
    required SizedShaftBuilderBits sizedBits,
    required TextStyle textStyle,
  }) = _TextBuilderBits;

  Bx centerLeft(String text) {
    final span = this.span(text);
    final textSize = span.size;
    return Bx.padOrFill(
      padding: Paddings.centerLeft(
        outer: sizedBits.size,
        inner: textSize,
      ),
      child: span.leaf(textSize),
      size: size,
    );
  }
}

extension TextSizedBitsX on SizedShaftBuilderBits {
  TextBuilderBits withTextStyle(TextStyle textStyle) => TextBuilderBits(
    sizedBits: this,
    textStyle: textStyle,
  );

  TextBuilderBits get headerText =>
      withTextStyle(themeCalc.shaftHeaderTextStyle);
  TextBuilderBits get itemText =>
      withTextStyle(themeCalc.menuItemTextStyle);
}
