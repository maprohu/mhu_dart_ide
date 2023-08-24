part of '../rect.dart';

Wx wxRectDivider({
  @ext required RectCtx rectCtx,
  required Axis layoutAxis,
  required double thickness,
}) {
  final size = rectCtx.size.sizeWithAxisDimension(
    axis: layoutAxis,
    dimension: thickness,
  );
  return createWx(
    widget: SizedBox.fromSize(
      size: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: rectCtx.themeWrapRender().dividerColor,
        ),
      ),
    ),
    size: size,
  );
}

Wx wxRectVerticalLayoutDivider({
  @ext required RectCtx rectCtx,
  required double thickness,
}) {
  return wxRectDivider(
    rectCtx: rectCtx,
    layoutAxis: Axis.vertical,
    thickness: thickness,
  );
}
Wx wxRectHorizontalLayoutDivider({
  @ext required RectCtx rectCtx,
  required double thickness,
}) {
  return wxRectDivider(
    rectCtx: rectCtx,
    layoutAxis: Axis.horizontal,
    thickness: thickness,
  );
}
