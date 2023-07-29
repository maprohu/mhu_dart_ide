import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';

import 'sized.dart';

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

@freezedStruct
class TextBuilder with _$TextBuilder {
  TextBuilder._();

  factory TextBuilder({
    required TextStyle textStyle,
  }) = _TextBuilder;

  late final height = mdiTextSize("", textStyle).height;

  SizedWidget text(
    String text, {
    TextAlign textAlign = TextAlign.start,
    TextOverflow overflow = TextOverflow.fade,
  }) {
    final size = mdiTextSize(text, textStyle);
    return SizedWidget(
      widget: RichText(
        text: TextSpan(
          text: text,
          style: textStyle,
        ),
        textAlign: textAlign,
        softWrap: false,
        overflow: overflow,
        maxLines: 1,
      ),
      height: size.height,
      width: size.width,
    );
  }
}
