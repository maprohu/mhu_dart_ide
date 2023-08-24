import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/context/shaft.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
export 'package:mhu_dart_ide/src/context/app.dart';

import 'window.dart' as $lib;

part 'window.g.dart';

part 'window.g.has.dart';

part 'window.freezed.dart';

@Has()
class WindowObj with MixDisposers, MixWindowCtx {
  late final Fr<Size> screenSizeFr;

  late final renderedViewFr = disposers.fr(
    () => windowCtx.watchWindowRenderedView(),
  );

  late final updateViewExecutor = renderedViewFr.createFrPausedExecutor();

  late final Fw<BeforeAfter<ShaftsLayout>> shaftsLayoutBeforeAfterFw =
      disposers.fw(
    (
      before: renderedViewFr.read().shaftsLayout,
      after: renderedViewFr.read().shaftsLayout,
    ),
  );

  late final onKeyEvent = this.windowOnKeyEvent();
}

@Compose()
@Has()
abstract class WindowCtx implements AppCtx, HasWindowObj {}

Future<WindowCtx> createWindowCtx({
  @Ext() required AppCtx appCtx,
  required Disposers disposers,
}) async {
  final windowObj = WindowObj()
    ..disposers = disposers
    ..screenSizeFr = await ScreenSizeObserver.stream(disposers).fr(disposers);

  final windowCtx = ComposedWindowCtx.appCtx(
    appCtx: appCtx,
    windowObj: windowObj,
  )..initMixWindowCtx(windowObj);

  windowObj.startWindowRenderStream();

  return windowCtx;
}

typedef OnKeyEvent = void Function(KeyEvent keyEvent);

@freezedStruct
class RenderedView with _$RenderedView {
  const RenderedView._();

  const factory RenderedView({
    required ShaftsLayout shaftsLayout,
    required OnKeyEvent onKeyEvent,
  }) = _RenderedView;

  // static final initial = RenderedView(
  //   shaftsLayout: ShaftsLayout.initial,
  //   onKeyEvent: ignore1,
  // );
}

RenderedView watchWindowRenderedView({
  @Ext() required WindowCtx windowCtx,
}) {
  return windowCtx.createRenderCtx().watchRenderRenderedView();
}

void startWindowRenderStream({
  @extHas required WindowObj windowObj,
}) {
  windowObj.renderedViewFr.changes().forEach(
    (renderedView) {
      windowObj.shaftsLayoutBeforeAfterFw.value = (
        before: windowObj.shaftsLayoutBeforeAfterFw.read().after,
        after: renderedView.shaftsLayout,
      );
    },
  );
}

OnKeyEvent windowOnKeyEvent({
  @extHas required WindowObj windowObj,
}) {
  return (keyEvent) {
    windowObj.renderedViewFr.read().onKeyEvent(keyEvent);
  };
}
