import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';
import 'package:mhu_dart_ide/src/bx/shortcut.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/options.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/bx/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../builder/sized.dart';
import 'divider.dart';
import 'menu.dart';
import 'boxed.dart';

part 'shaft.freezed.dart';

@freezedStruct
class ShaftParts with _$ShaftParts {
  ShaftParts._();

  factory ShaftParts({
    required Bx header,
    required Bx content,
  }) = _ShaftParts;
}

typedef ShaftBuilder = ShaftParts Function(
  SizedShaftBuilderBits headerBits,
  SizedShaftBuilderBits contentBits,
);

Bx shaftBx({
  required SizedShaftBuilderBits sizedBits,
  required ShaftBuilder builder,
}) {
  final SizedShaftBuilderBits(
    :size,
    :width,
    :height,
    :themeCalc,
  ) = sizedBits;

  final ThemeCalc(
    :shaftHeaderDividerThickness,
    :shaftHeaderWithDividerHeight,
    :shaftHeaderPadding,
    :shaftHeaderContentHeight,
    :shaftHeaderOuterHeight,
  ) = themeCalc;

  final headerContentWidth = width - shaftHeaderPadding.horizontal;
  final contentHeight = height - shaftHeaderWithDividerHeight;

  final parts = builder(
    sizedBits.withSize(Size(headerContentWidth, shaftHeaderContentHeight)),
    sizedBits.withSize(Size(width, contentHeight)),
  );

  return Bx.col(
    size: size,
    rows: [
      Bx.pad(
        padding: shaftHeaderPadding,
        child: parts.header,
        size: size.withHeight(shaftHeaderOuterHeight),
      ),
      horizontalDividerBx(
        thickness: shaftHeaderDividerThickness,
        width: width,
      ),
      parts.content,
    ],
  );
}

extension ShaftSizedBitsX on SizedShaftBuilderBits {
  Bx shaft(
    ShaftBuilder builder,
  ) {
    return shaftBx(
      sizedBits: this,
      builder: builder,
    );
  }

  Bx menuShaft({
    required String label,
    required List<MenuItem> items,
  }) {
    return shaft(
      (headerBits, contentBits) {
        final pageBx = menuBx(
          sizedBits: contentBits,
          itemCount: items.length,
          itemBuilder: (index, sizedBits) {
            return menuItemBx(
              menuItem: items[index],
              sizedBits: sizedBits,
            );
          },
        );

        return ShaftParts(
          header: headerBits.left(
            headerBits.centerHeight(
              textBx(
                text: label,
                style: themeCalc.shaftHeaderTextStyle,
              ),
            ),
          ),
          content: pageBx,
        );
      },
    );
  }

  Bx header({
    required String label,
    VoidCallback? callback,
  }) {
    if (callback == null) {
      return headerText.centerLeft(label);
    }

    return fillLeft(
      left: (sizedBits) => sizedBits.headerText.centerLeft(label),
      right: centerHeight(
        shaftBits.shortcut(callback),
      ),
    );
  }
}

Bx defaultShaftBx({
  required SizedShaftBuilderBits sizedBits,
  required ShaftCalc shaftCalc,
}) {
  return shaftBx(
    sizedBits: sizedBits,
    builder: (headerBits, contentBits) {
      final content = shaftCalc.buildShaftContent(contentBits);
      return ShaftParts(
        header: headerBits.fillLeft(
          left: (sizedBits) => sizedBits.headerText.centerLeft(
            shaftCalc.label,
          ),
          right: headerBits.centerHeight(
            headerBits.shaftBits.shortcut(
              headerBits.optionsOpenerCallback(),
            ),
          ),
        ),
        content: content,
      );
    },
  );
}
