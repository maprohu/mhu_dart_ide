import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_ide/src/context/shaft.dart';
export 'package:mhu_dart_ide/src/context/shaft.dart';

import 'rect.dart' as $lib;

part 'rect.g.dart';

part 'rect.g.has.dart';

part 'rect.g.compose.dart';

@Has()
class RectObj {}

@Compose()
abstract class RectCtx implements ShaftCtx, HasRectObj {}

RenderCtx createRectCtx({
  @Ext() required ShaftCtx shaftCtx,
}) {
  final rectObj = RectObj();

  return ComposedRectCtx.shaftCtx(
    shaftCtx: shaftCtx,
    rectObj: rectObj,
  );
}
