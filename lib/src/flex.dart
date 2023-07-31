import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';

part 'flex.freezed.dart';

@freezedStruct
class FlexNode<T> with _$FlexNode<T> {
  FlexNode._();

  factory FlexNode({
    required bool grow,
    required T Function(double size) builder,
  }) = _FlexNode;

  factory FlexNode.grow(
    T Function(double size) builder,
  ) =>
      FlexNode(
        grow: true,
        builder: builder,
      );

  factory FlexNode.fix(
    T Function(double size) builder,
  ) =>
      FlexNode(
        grow: false,
        builder: builder,
      );
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

@freezedStruct
sealed class ExpandNode<T> with _$ExpandNode<T> {
  ExpandNode._();

  factory ExpandNode.fix({
    required double size,
    required T item,
  }) = ExpandNodeFix;

  factory ExpandNode.grow({
    required T Function(double size) builder,
  }) = ExpandNodeGrow;

  static ExpandNode<Widget> height(
    HasHWidget sizedWidget,
  ) =>
      ExpandNode.fix(
        size: sizedWidget.height,
        item: sizedWidget.widget,
      );

  static ExpandNode<Widget> width(
    HasVWidget sizedWidget,
  ) =>
      ExpandNode.fix(
        size: sizedWidget.width,
        item: sizedWidget.widget,
      );
}

Iterable<T> buildExpand<T>({
  required double availableSpace,
  required List<ExpandNode<T>> items,
}) {
  assert(items.any((e) => e is ExpandNodeGrow));

  final (:fixSize, :growCount) = items.fold(
    (fixSize: 0.0, growCount: 0),
    (previousValue, element) => switch (element) {
      ExpandNodeFix() => (
          fixSize: previousValue.fixSize + element.size,
          growCount: previousValue.growCount,
        ),
      _ => (
          fixSize: previousValue.fixSize,
          growCount: previousValue.growCount + 1,
        ),
    },
  );

  final growSpace = availableSpace - fixSize;
  final growSize = growSpace / growCount;
  return items.map((node) {
    return switch (node) {
      ExpandNodeFix() => node.item,
      ExpandNodeGrow() => node.builder(growSize),
    };
  });
}

