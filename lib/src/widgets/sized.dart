import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

part 'sized.freezed.dart';

@freezedStruct
class SizedWidget with _$SizedWidget implements HasSizedWidget {
  const SizedWidget._();

  @Assert("widget is! SizedBox")
  const factory SizedWidget({
    required Widget widget,
    required double width,
    required double height,
  }) = _SizedWidget;

  factory SizedWidget.zero(Widget widget) => SizedWidget(
        widget: widget,
        width: 0,
        height: 0,
      );
}

const nullSizedWidget = SizedWidget(
  widget: nullWidget,
  width: 0,
  height: 0,
);

Size mdiTextSize(String text, TextStyle style) {
  return TextSpan(
    text: text,
    style: style,
  ).size;
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

SizedWidget columnDivider([double thickness = 1]) {
  return SizedWidget(
    widget: Divider(
      height: thickness,
      thickness: thickness,
      indent: 0,
      endIndent: 0,
    ),
    height: thickness,
    width: 0,
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
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return SizedWidget(
    widget: Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children.map((e) => e.widget).toList(),
    ),
    height: children.sumByDouble((e) => e.height),
    width: children.map((e) => e.width).maxOrNull ?? 0,
  );
}

SizedWidget sizedRow({
  required List<HasSizedWidget> children,
  Object? widgetKey,
}) {
  return SizedWidget(
    widget: Row(
      key: widgetKey?.let(ValueKey.new),
      children: children.map((e) => e.widget).toList(),
    ),
    width: children.sumByDouble((e) => e.width),
    height: children.map((e) => e.height).maxOrNull ?? 0,
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

SizedWidget rowGap([double width = 1]) => SizedWidget(
      widget: SizedBox(
        width: width,
      ),
      height: 0,
      width: width,
    );

extension SizedWidgetWidgetX on Widget {
  HWidget withHwHeight(double height) => HWidget(
        widget: this,
        height: height,
      );

  SizedWidget sizedWith(Size size) => sizedFrom(
        width: size.width,
        height: size.height,
      );

  SizedWidget sizedFrom({
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
        child: widget,
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

  SizedWidget withWidget(Widget widget) => SizedWidget(
        widget: widget,
        width: width,
        height: height,
      );

  HasSizedWidget get expanded => withWidget(
        Expanded(child: widget),
      );

  HasSizedWidget sizedBox({
    double? width,
    double? height,
  }) {
    if (width == null && height == null) return this;
    return SizedBox(
      width: width,
      height: height,
      child: widget,
    ).sizedFrom(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}

extension SizedTextSpanX on TextSpan {
  Size get size {
    final TextPainter textPainter = TextPainter(
      text: this,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );
    return textPainter.size;
  }
}
