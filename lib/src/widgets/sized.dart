import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/ui.dart';

import '../op.dart';

part 'sized.freezed.dart';

@freezedStruct
class SizedWidget with _$SizedWidget implements HasSizedWidget {
  SizedWidget._();

  factory SizedWidget({
    required Widget widget,
    required double width,
    required double height,
  }) = _SizedWidget;
}

Size mdiTextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
  return textPainter.size;
}

abstract class HasWidget {
  Widget get widget;
}

abstract class HasHeight {
  double get height;
}

abstract class HasWidth {
  double get width;
}

abstract class HasHWidget implements HasWidget, HasHeight {}

abstract class HasVWidget implements HasWidget, HasWidth {}

abstract class HasSizedWidget implements HasHWidget, HasVWidget {}

@freezedStruct
class HWidget with _$HWidget implements HasHWidget {
  HWidget._();

  factory HWidget({
    required Widget widget,
    required double height,
  }) = _HWidget;
}

HWidget hwRow({
  required List<HWidget> children,
}) {
  return HWidget(
    widget: Row(
      children: children.map((e) => e.widget).toList(),
    ),
    height: children.map((e) => e.height).maxOrNull ?? 0,
  );
}

SizedWidget sizedPadding({
  required HasSizedWidget child,
  double all = 2,
  double? top,
  double? bottom,
  double? left,
  double? right,
}) {
  top ??= all;
  bottom ??= all;
  left ??= all;
  right ??= all;

  return SizedWidget(
    widget: Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: child.widget,
    ),
    height: child.height + top + bottom,
    width: child.width + left + right,
  );
}
HWidget hwPadding({
  required HasHWidget child,
  double all = 2,
  double? top,
  double? bottom,
  double? left,
  double? right,
}) {
  top ??= all;
  bottom ??= all;
  left ??= all;
  right ??= all;

  return HWidget(
    widget: Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: child.widget,
    ),
    height: child.height + top + bottom,
  );
}

HWidget hwDivider([double thickness = 1]) {
  return HWidget(
    widget: Divider(
      height: thickness,
      thickness: thickness,
      indent: 0,
      endIndent: 0,
    ),
    height: thickness,
  );
}

SizedWidget sizedColumn({
  required List<HasSizedWidget> children,
}) {
  return SizedWidget(
    widget: Column(
      children: children.map((e) => e.widget).toList(),
    ),
    height: children.sumBy((e) => e.height),
    width: children.map((e) => e.width).maxOrNull ?? 0,
  );
}

HWidget hwColumn({
  required List<HasHWidget> children,
}) {
  return HWidget(
    widget: Column(
      children: children.map((e) => e.widget).toList(),
    ),
    height: children.sumBy((e) => e.height),
  );
}

extension HWidgetX on HWidget {
  HWidget withPadding({
    double all = 2,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return hwPadding(
      child: this,
      all: all,
      top: top,
      bottom: bottom,
      left: left,
    );
  }

  HWidget mapWidget(Widget Function(Widget child) mapper) => copyWith(
        widget: mapper(widget),
      );
}

SizedWidget columnGap([double height = 1]) => SizedWidget(
      widget: SizedBox(
        height: height,
      ),
      height: height,
      width: 0,
    );

HasSizedWidget sizedKeys({
  required Keys? keys,
  required UiBuilder ui,
}) {
  final chars = keys?.chars ?? '';
  return ui.keysText.text(chars).constrain(minWidth: 16);
}

SizedWidget sizedOpIcon({
  required HasSizedWidget icon,
  required Keys? keys,
  required UiBuilder ui,
}) {
  return sizedColumn(children: [
    icon,
    columnGap(),
    sizedKeys(
      keys: keys,
      ui: ui,
    ),
  ]).withPadding();
}

extension SizedWidgetWidgetX on Widget {
  HWidget withHwHeight(double height) => HWidget(
        widget: this,
        height: height,
      );

  SizedWidget withSize({
    required double width,
    required double height,
  }) =>
      SizedWidget(
        widget: this,
        width: width,
        height: height,
      );
}

extension HWidgetIterableX on Iterable<HasWidget> {
  List<Widget> get widgets => map((e) => e.widget).toList();
}

extension SizedWidgetX on HasSizedWidget {
  HasSizedWidget constrain({
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  }) {
    final width = constrainOrNull(this.width, minWidth, maxWidth);
    final height = constrainOrNull(this.height, minHeight, maxHeight);

    if (width == null && height == null) {
      return this;
    }

    return SizedWidget(
      widget: SizedBox(
        width: width,
        height: height,
      ),
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  SizedWidget withPadding({
    double all = 2,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return sizedPadding(
      child: this,
      all: all,
      top: top,
      bottom: bottom,
      left: left,
    );
  }
}
