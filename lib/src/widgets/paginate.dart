import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/divider.dart';
import 'package:mhu_dart_ide/src/icons.dart';
import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/shaft.dart';
import 'package:mhu_dart_ide/src/widgets/shortcut.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../theme.dart';
import 'boxed.dart';

int itemFitCount({
  required double available,
  required double itemSize,
  required double dividerThickness,
}) {
  final remaining = available - itemSize;
  if (remaining < 0) {
    return 0;
  }

  return 1 + (remaining ~/ (itemSize + dividerThickness));
}

Bx showPaginatorShortcutBx({
  required ThemeCalc themeCalc,
  required ShortcutData? shortcutData,
}) {
  return shortcutWithIconBx(
    themeCalc: themeCalc,
    icon: MdiIcons.pages,
    shortcutData: shortcutData,
  );
}

typedef PaginatorBx = ({
  Bx bx,
  bool showPaginator,
});

Bx paginatorAlongYBx({
  required SizedNodeBuilderBits sizedBits,
  required double itemHeight,
  required int itemCount,
  required int startAt,
  required Bx Function(int index, SizedNodeBuilderBits sizedBits) itemBuilder,
  required double dividerThickness,
}) {
  final SizedNodeBuilderBits(
    :themeCalc,
  ) = sizedBits;
  Bx page({
    required SizedNodeBuilderBits sizedBits,
    required int startAt,
    required int count,
    required bool stretch,
  }) {
    int dividerCount = count - 1;

    var itemBits = sizedBits.withHeight(itemHeight);

    final divider = Bx.horizontalDivider(
      thickness: dividerThickness,
      width: sizedBits.width,
    );
    Bx itemsBx(Size size) {
      return Bx.col(
        rows: integers(from: startAt)
            .take(count)
            .map(
              (index) => itemBuilder(index, itemBits),
            )
            .separatedBy(divider)
            .toList(),
        size: size,
      );
    }

    if (stretch) {
      itemBits = itemBits.withHeight(
        (sizedBits.height - (dividerCount * dividerThickness)) / count,
      );

      return itemsBx(sizedBits.size);
    } else {
      return sizedBits.top(
        itemsBx(
          sizedBits.size.withHeight(
            dividerCount * dividerThickness + itemHeight * count,
          ),
        ),
      );
    }
  }

  if (itemCount == 0) {
    return sizedBits.fill();
  }

  final fitCount = itemFitCount(
    available: sizedBits.height,
    itemSize: itemHeight,
    dividerThickness: dividerThickness,
  );

  if (itemCount == fitCount) {
    return page(
      sizedBits: sizedBits,
      startAt: 0,
      count: itemCount,
      stretch: true,
    );
  } else if (itemCount < fitCount) {
    return page(
      sizedBits: sizedBits,
      startAt: 0,
      count: itemCount,
      stretch: false,
    );
  } else {
    final footer = Bx.fillWith(
      width: sizedBits.width,
      height: themeCalc.paginatorFooterOuterHeight,
    );
    return sizedBits.fillTop(
      top: (sizedBits) => sizedBits.fillTop(
        top: (sizedBits) {
          final fitCount = itemFitCount(
            available: sizedBits.height,
            itemSize: itemHeight,
            dividerThickness: dividerThickness,
          );

          startAt = min(startAt, itemCount - fitCount);

          return page(
            sizedBits: sizedBits,
            startAt: startAt,
            count: fitCount,
            stretch: true,
          );
        },
        bottom: sizedBits.horizontalDivider(
          themeCalc.paginatorFooterDividerThickness,
        ),
      ),
      bottom: footer,
    );
  }
}
