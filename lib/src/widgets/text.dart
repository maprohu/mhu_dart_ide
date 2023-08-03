import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/string.dart';
import 'package:mhu_dart_ide/src/widgets/boxed.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

part 'text.freezed.dart';

Widget mdiText({
  required String text,
  required TextStyle style,
}) {
  return RichText(
    text: TextSpan(
      text: text,
      style: style,
    ),
  );
}

// @freezedStruct
// class TextBuilder with _$TextBuilder {
//   TextBuilder._();
//
//   factory TextBuilder({
//     required TextStyle textStyle,
//   }) = _TextBuilder;
//
//   late final height = mdiTextSize(" ", textStyle).height;
//
//   SizedWidget text(
//     String text, {
//     TextAlign textAlign = TextAlign.start,
//     TextOverflow overflow = TextOverflow.fade,
//   }) {
//     return sizedTextSpan(
//       TextSpan(
//         text: text,
//         style: textStyle,
//       ),
//       textAlign: textAlign,
//       overflow: overflow,
//     );
//   }
// }

// SizedWidget sizedTextSpan(
//   TextSpan textSpan, {
//   TextAlign textAlign = TextAlign.start,
//   TextOverflow overflow = TextOverflow.fade,
// }) {
//   final size = textSpan.size;
//
//   return SizedWidget(
//     widget: RichText(
//       text: textSpan,
//       textAlign: textAlign,
//       softWrap: false,
//       overflow: overflow,
//       maxLines: 1,
//     ),
//     height: size.height,
//     width: size.width,
//   );
// }

extension TextSizedBuilderX on SizedShaftBuilderBits {
  Bx text(String text) {
    return leaf(
      Text(text),
    );
  }
}

extension SizedTextSpanX on TextSpan {
  Size get size {
    final TextPainter textPainter = TextPainter(
      text: this,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );
    return textPainter.size;
  }

  Bx leaf([Size? size]) => Bx.leaf(
        size: size ?? this.size,
        widget: RichText(
          text: this,
        ),
      );
}

Size mdiTextSize(String text, TextStyle style) {
  return TextSpan(
    text: text,
    style: style,
  ).size;
}

Bx textBx({
  required String text,
  required TextStyle style,
}) {
  final textSpan = TextSpan(
    text: text,
    style: style,
  );

  return Bx.leaf(
    size: textSpan.size,
    widget: RichText(
      text: textSpan,
    ),
  );
}

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
    return Bx.pad(
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
