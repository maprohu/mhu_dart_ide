import 'package:mhu_dart_commons/commons.dart';

import '../screen/calc.dart';

class ShaftDoubleChain
    with
        HasShaftCalc,
        HasShaftCalcChain,
        HasShaftMsg,
        HasParent<ShaftDoubleChain>,
        HasNext<ShaftDoubleChain> {
  @override
  final ShaftDoubleChain? parent;

  @override
  final ShaftCalc shaftCalc;

  @override
  late final next = ShaftDoubleChain(
    parent: this,
    shaftCalc: shaftCalc.shaftCalcChain.parent!.calc,
  );

  bool get hasLeft => shaftCalc.shaftCalcChain.parent != null;

  ShaftDoubleChain? get left => hasLeft ? next : null;

  ShaftDoubleChain? get right => parent;

  Iterable<ShaftDoubleChain> get iterableLeft sync* {
    yield this;
    final left = this.left;
    if (left != null) {
      // wonder if there is tail recursion optimization?
      yield* left.iterableLeft;
    }
  }

  late int parentWidthToEnd = parent?.widthToEnd ?? 0;

  late int widthToEnd = parentWidthToEnd + shaftWidth;

  ShaftDoubleChain({
    this.parent,
    required this.shaftCalc,
  });
}

mixin HasShaftDoubleChain {
  ShaftDoubleChain get doubleChain;

  late final shaftCalc = doubleChain.shaftCalc;
}
