import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/src/bx/boxed.dart';



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
  Size wrapSize(double width) {
    final TextPainter textPainter = TextPainter(
      text: this,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: width,
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


