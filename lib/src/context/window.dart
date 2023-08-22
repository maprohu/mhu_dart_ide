import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/screen.dart';
import 'package:mhu_dart_ide/src/context/app.dart';
import 'package:mhu_dart_ide/src/context/shaft.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
export 'package:mhu_dart_ide/src/context/app.dart';

import 'window.dart' as $lib;

part 'window.g.dart';

part 'window.g.has.dart';

part 'window.g.compose.dart';

part 'window.freezed.dart';

@Has()
class WindowObj {
  late final Fr<Size> screenSizeFr;
}

@Compose()
abstract class WindowCtx implements AppCtx, HasWindowObj {}

Future<WindowCtx> createWindowCtx({
  @Ext() required AppCtx appCtx,
  required Disposers disposers,
}) async {
  final windowObj = WindowObj()
    ..screenSizeFr = await ScreenSizeObserver.stream(disposers).fr(disposers);

  return ComposedWindowCtx.appCtx(
    appCtx: appCtx,
    windowObj: windowObj,
  );
}

typedef OnKeyEvent = void Function(KeyEvent keyEvent);

@freezedStruct
class RenderedView with _$RenderedView {
  RenderedView._();

  factory RenderedView({
    required ShaftsLayout shaftsLayout,
    required OnKeyEvent onKeyEvent,
  }) = _RenderedView;
}

RenderedView watchWindowRenderedView({
  @Ext() required WindowCtx windowCtx,
}) {
  return windowCtx
      .createRenderCtx(
        stateMsg: windowCtx.watchStateMsg(),
      )
      .watchRenderRenderedView();
}
