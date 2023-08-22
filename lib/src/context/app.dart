import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_ide/src/context/config.dart';
import 'package:mhu_dart_ide/src/context/tasks.dart';
export 'package:mhu_dart_ide/src/context/tasks.dart';
import 'package:mhu_dart_ide/src/context/theme.dart';
export 'package:mhu_dart_ide/src/context/theme.dart';
export 'package:mhu_dart_ide/src/context/config.dart';
import 'app.dart' as $lib;

part 'app.g.dart';

part 'app.g.has.dart';

part 'app.g.compose.dart';

@Has()
class AppObj {}

@Compose()
abstract class AppCtx
    implements ConfigCtx, HasAppObj, HasThemeObj, HasTasksObj {}

AppCtx createAppCtx({
  @Ext() required ConfigCtx configCtx,
}) {
  final appObj = AppObj();

  final themeObj = configCtx.createThemeObj();

  final tasksObj = configCtx.createTasksObj();

  return ComposedAppCtx.configCtx(
    configCtx: configCtx,
    appObj: appObj,
    themeObj: themeObj,
    tasksObj: tasksObj,
  );
}
