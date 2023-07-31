import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';


part 'paginate.freezed.dart';

class HwPaginatorController {
  final firstIndex = fw(0);
}


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

@freezedStruct
class PaginatorBits with _$PaginatorBits {
  PaginatorBits._();

  factory PaginatorBits({
    required double itemHeight,
    required int itemCount,
    required Iterable<Widget> Function(
      int from,
      int count,
      DspReg disposers,
    ) itemBuilder,
  }) = _PaginatorBits;
}

typedef PaginatorRegistrar = PaginatorBits Function(DspReg disposers);

