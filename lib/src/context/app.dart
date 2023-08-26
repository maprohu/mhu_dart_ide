import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/rect.dart';
export 'package:mhu_shafts/src/context/tasks.dart';
export 'package:mhu_shafts/src/context/theme.dart';
export 'package:mhu_shafts/src/context/data.dart';
import 'app.dart' as $lib;

part 'app.g.dart';

part 'app.g.has.dart';

@Has()
class AppObj with MixAppCtx {
  late final WindowCtx windowCtx;
}

@Compose()
@Has()
abstract class AppCtx implements DataCtx, HasAppObj, HasTasksObj {}

Future<AppCtx> createAppCtx({
  @Ext() required DataCtx dataCtx,
  required Disposers disposers,
}) async {
  final appObj = AppObj();

  final tasksObj = dataCtx.createTasksObj();

  final appCtx = ComposedAppCtx.dataCtx(
    dataCtx: dataCtx,
    appObj: appObj,
    tasksObj: tasksObj,
  )..initMixAppCtx(appObj);

  appObj.windowCtx = await appCtx.createWindowCtx(
    disposers: disposers,
  );

  return appCtx;
}

