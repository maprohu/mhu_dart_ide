import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/bx/boxed.dart';
import 'package:mhu_dart_ide/src/bx/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../builder/sized.dart';
import 'share.dart';

part 'string.g.compose.dart';

@Compose()
abstract class MonoTextStyle implements HasSize, HasTextStyle {
  static const _calcCount = 10000;

  static MonoTextStyle from(TextStyle textStyle) => ComposedMonoTextStyle(
        size: mdiTextSize(
          Iterable.generate(
            _calcCount,
            (_) => "M",
          ).join(),
          textStyle,
        ).let((s) {
          return Size(s.width / _calcCount, s.height);
        }),
        textStyle: textStyle.apply(
            // fontFeatures: [
            //   FontFeature.tabularFigures(),
            // ],
            ),
      );
}

SharingBx stringVerticalSharingBx({
  required SizedShaftBuilderBits sizedBits,
  required String string,
}) {
  return ComposedSharingBx(
    intrinsicDimension: sizedBits.themeCalc.stringTextStyle.height,
    dimensionBxBuilder: (dimension) {
      return stringBx(
        sizedBits: sizedBits.withHeight(dimension),
        string: string,
      );
    },
  );
}

Bx stringBx({
  required SizedShaftBuilderBits sizedBits,
  required String string,
}) {
  final style = sizedBits.themeCalc.stringTextStyle;

  final styleWidth = style.width;

  final fitWidth = sizedBits.width ~/ styleWidth;
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

  final linesCol = Bx.col(
    rows: lines.map(
      (line) {
        final lineSpan = style.span(line);
        return lineBits.leaf(
          RichText(
            text: lineSpan,
            softWrap: false,
          ),
        );
      },
    ).toList(),
    size: linesSize,
  );

  return sizedBits.topLeft(linesCol);
}

abstract class HasTextStyle {
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
