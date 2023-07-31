import 'package:mhu_dart_commons/commons.dart';

part 'flex.freezed.dart';

@freezedStruct
class FlexNode<T> with _$FlexNode<T> {
  FlexNode._();

  factory FlexNode({
    required bool grow,
    required T Function(double size) builder,
  }) = _FlexNode;
}

Iterable<T> buildFlex<T>({
  required double availableSpace,
  required double fixedSize,
  required double? dividerThickness,
  required List<FlexNode<T>> items,
}) {
  final count = items.length;

  if (dividerThickness != null) {
    availableSpace -= (count - 1) * dividerThickness;
  }

  final hasGrow = items.any((node) => node.grow);

  if (hasGrow) {
    final fixedCount = items.where((node) => !node.grow).length;
    final growCount = count - fixedCount;
    final growSpace = availableSpace - (fixedCount * fixedSize);
    final growSize = growSpace / growCount;
    return items.map((node) {
      return node.builder(
        node.grow ? growSize : fixedSize,
      );
    });
  } else {
    final size = availableSpace / count;

    return items.map((node) {
      return node.builder(size);
    });
  }
}
