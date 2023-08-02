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

Bx paginatorAlongYBx({
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
    return sizedBits.fill();
  }

  final fitCount = itemFitCount(
    available: height,
    itemSize: itemHeight,
    dividerThickness: dividerThickness,
  );

  startAt = min(startAt, itemCount - fitCount);
  startAt = max(startAt, 0);

  final itemsLeft = itemCount - startAt;
  final displayCount =

  final divider = Bx.horizontalDivider(
    thickness: dividerThickness,
    width: width,
  );


  Iterable<int> itemIndices() => integers(from: startAt);

  bool hasItemsBefore = startAt > 0;

  Iterable<Bx> bxs(SizedNodeBuilderBits itemBits, int count) {
    return itemIndices().take(count)
        .map((index) => itemBuilder(index, itemBits))
        .separatedBy(divider);
  }

  if (itemsLeft < fitCount) {
    final itemBits = sizedBits.withHeight(itemHeight);
    final dividerCount = itemsLeft - 1;

    return (
      bx: sizedBits.top(
        Bx.col(
          bxs(itemBits, itemsLeft).toList(),
        ),
      ),
      showPaginator: hasItemsBefore,
    );
  } else {
    final dividerCount = fitCount - 1;
    final itemHeight = (height - (dividerCount * dividerThickness)) / fitCount;
    final itemBits = sizedBits.withHeight(itemHeight);

    bool hasItemsAfter = itemsLeft > fitCount;
    return (
      bx: Bx.col(
        bxs(itemBits, fitCount).toList(),
      ),
      showPaginator: hasItemsBefore || hasItemsAfter,
    );
  }
}
