import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_ide/src/context/app.dart';

import 'theme.dart' as $lib;

part 'theme.g.dart';

part 'theme.g.has.dart';
// part 'theme.g.compose.dart';

@Has()
class ThemeObj {}

ThemeObj createThemeObj({
  @Ext() required ConfigCtx configCtx,
}) {
  final themeObj = ThemeObj();
  return themeObj;
}
