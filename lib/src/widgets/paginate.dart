import 'dart:math';

import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/icons.dart';
import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/widgets/shortcut.dart';

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

PaginatorBx paginatorAlongYBx({
  required SizedNodeBuilderBits sizedBits,
  required double itemHeight,
  required int itemCount,
  required int startAt,
  required Bx Function(int index, SizedNodeBuilderBits sizedBits) itemBuilder,
  required double dividerThickness,
}) {
  final SizedNodeBuilderBits(
    :width,
    :height,
  ) = sizedBits;

  if (itemCount == 0) {
    return (
      bx: sizedBits.fill(),
      showPaginator: false,
    );
  }

  startAt = min(startAt, itemCount - 1);

  final fitCount = itemFitCount(
    available: sizedBits.height,
    itemSize: itemHeight,
    dividerThickness: dividerThickness,
  );

  final divider = Bx.horizontalDivider(
    thickness: dividerThickness,
    width: width,
  );

  final itemsLeft = itemCount - startAt;

  Iterable<int> itemIndices(int count) => integers(from: startAt).take(count);

  bool hasItemsBefore = startAt > 0;

  Iterable<Bx> bxs(SizedNodeBuilderBits itemBits) {
    return itemIndices(itemsLeft)
        .map((index) => itemBuilder(index, itemBits))
        .separatedBy(divider);
  }

  if (itemsLeft < fitCount) {
    final dividerCount = itemsLeft - 1;
    final itemsHeight =
        itemsLeft * itemHeight + dividerCount * dividerThickness;
    final fillHeight = height - itemsHeight;
    final itemBits = sizedBits.withHeight(itemHeight);
    return (
      bx: Bx.col([
        ...bxs(itemBits),
        sizedBits.fillHeight(fillHeight),
      ]),
      showPaginator: hasItemsBefore,
    );
  } else {
    final dividerCount = fitCount - 1;
    final itemHeight = (height - (dividerCount * dividerThickness)) / fitCount;
    final itemBits = sizedBits.withHeight(itemHeight);

    bool hasItemsAfter = itemsLeft > fitCount;
    return (
      bx: Bx.col(bxs(itemBits).toList()),
      showPaginator: hasItemsBefore || hasItemsAfter,
    );
  }
}
