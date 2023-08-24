part of '../rect.dart';

Wx wxRectFillLeft({
  @ext required RectCtx rectCtx,
  required WxRectBuilder left,
  required Iterable<Wx> right,
}) {
  return rectCtx.wxFillLeft(
    left: (width) {
      return left(
        rectCtx.rectWithWidth(
          width: width,
        ),
      );
    },
    right: right,
  );
}

Wx wxRectFillBottom({
  @ext required RectCtx rectCtx,
  required Iterable<Wx> top,
  required WxRectBuilder bottom,
}) {
  return rectCtx.wxFillBottom(
    top: top,
    bottom: (height) {
      return bottom(
        rectCtx.rectWithHeight(
          height: height,
        ),
      );
    },
  );
}
