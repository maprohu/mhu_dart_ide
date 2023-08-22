import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/screen.dart';
import 'package:mhu_dart_ide/src/context/shaft.dart';
import 'package:mhu_dart_ide/src/context/window.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
export 'package:mhu_dart_ide/src/context/window.dart';
import '../../proto.dart';
import 'render.dart' as $lib;

part 'render.g.dart';

part 'render.g.has.dart';

part 'render.g.compose.dart';

@Has()
class RenderObj with MixRenderCtx, MixStateMsg {
  late final shaftList = renderCtx.createShaftList();
}

@Compose()
@Has()
abstract class RenderCtx implements WindowCtx, HasRenderObj {}

RenderCtx createRenderCtx({
  @Ext() required WindowCtx windowCtx,
  required StateMsg stateMsg,
}) {
  final renderObj = RenderObj().also(stateMsg.initMixStateMsg);

  return ComposedRenderCtx.windowCtx(
    windowCtx: windowCtx,
    renderObj: renderObj,
  )..initMixRenderCtx(renderObj);
}

RenderedView watchRenderRenderedView({
  @Ext() required RenderCtx windowCtx,
}) {
  return RenderedView(
    shaftsLayout: shaftsLayout,
    onKeyEvent: onKeyEvent,
  );
}

StateMsg getRenderStateMsg({
  @extHas required RenderObj renderObj,
}) {
  return renderObj.stateMsg;
}
