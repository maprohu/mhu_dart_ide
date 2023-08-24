import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_ide/src/context/shaft.dart';
import 'package:mhu_dart_ide/src/wx/wx.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
export 'package:mhu_dart_ide/src/context/shaft.dart';

import 'rect.dart' as $lib;

part 'rect.g.dart';

// part 'rect.g.has.dart';

part 'rect/fill.dart';

part 'rect/padding.dart';

part 'rect/divider.dart';

typedef WxRectBuilder = Wx Function(RectCtx rectCtx);

// @Has()
// @Compose()
// abstract base class RectObj implements HasSize {}

@Compose()
abstract class RectCtx implements ShaftCtx, HasSize {}

RectCtx createRectCtx({
  @Ext() required ShaftCtx shaftCtx,
  required Size size,
}) {
  return ComposedRectCtx.shaftCtx(
    shaftCtx: shaftCtx,
    size: size,
  );
}

RectCtx rectWithSize({
  @ext required RectCtx rectCtx,
  @extHas required Size size,
}) {
  return rectCtx.createRectCtx(
    size: size,
  );
}

RectCtx rectWithWidth({
  @ext required RectCtx rectCtx,
  required double width,
}) {
  return rectCtx.rectWithSize(
    size: rectCtx.sizeWithWidth(
      width: width,
    ),
  );
}

RectCtx rectWithHeight({
  @ext required RectCtx rectCtx,
  required double height,
}) {
  return rectCtx.rectWithSize(
    size: rectCtx.sizeWithHeight(
      height: height,
    ),
  );
}
