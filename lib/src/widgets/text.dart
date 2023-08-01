import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/widgets/boxed.dart';

// part 'text.freezed.dart';

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

extension TextSizedBuilderX on SizedNodeBuilderBits {
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
