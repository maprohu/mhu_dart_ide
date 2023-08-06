import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/bx/divider.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../builder/sized.dart';
import 'boxed.dart';
import 'share.dart';

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

typedef PaginatorBx = ({
  Bx bx,
  bool showPaginator,
});

SharingBx paginatorAlongYSharingBx({
  required SizedShaftBuilderBits sizedBits,
  required double itemHeight,
  required int itemCount,
  required int startAt,
  required Bx Function(int index, SizedShaftBuilderBits sizedBits) itemBuilder,
  required double dividerThickness,
  SharingBx? emptyBx,
}) {
  if (itemCount == 0) {
    return emptyBx ??
        ComposedSharingBx(
          intrinsicDimension: 0,
          dimensionBxBuilder: (dimension) =>
              sizedBits.withHeight(dimension).fill(),
        );
  }
  final intrinsicHeight =
      itemCount * itemHeight + (itemCount - 1) * dividerThickness;
  return ComposedSharingBx(
    intrinsicDimension: intrinsicHeight,
    dimensionBxBuilder: (dimension) {
      return paginatorAlongYBx(
        sizedBits: sizedBits.withHeight(dimension),
        itemHeight: itemHeight,
        itemCount: itemCount,
        startAt: startAt,
        itemBuilder: itemBuilder,
        dividerThickness: dividerThickness,
      );
    },
  );
}

Bx paginatorAlongYBx({
  required SizedShaftBuilderBits sizedBits,
  required double itemHeight,
  required int itemCount,
  required int startAt,
  required Bx Function(int index, SizedShaftBuilderBits sizedBits) itemBuilder,
  required double dividerThickness,
  SharingBx? emptyBx,
}) {
  final themeCalc = sizedBits.themeCalc;
  Bx page({
    required SizedShaftBuilderBits sizedBits,
    required int startAt,
    required int count,
    required bool stretch,
  }) {
    int dividerCount = count - 1;

    var itemBits = sizedBits.withHeight(itemHeight);

    final divider = horizontalDividerBx(
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
