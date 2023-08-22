import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_ide/src/context/app.dart';
import 'tasks.dart' as $lib;

part 'tasks.g.dart';

part 'tasks.g.has.dart';
// part 'tasks.g.compose.dart';

@Has()
class TasksObj {}

TasksObj createTasksObj({
  @Ext() required ConfigCtx configCtx,
}) {
  final tasksObj = TasksObj();

  return tasksObj;
}
