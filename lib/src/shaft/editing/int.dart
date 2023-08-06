import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

final BuildShaftOptions intEditOptions = (shaftBits) {
  return [
    shaftBits.openerField(MdiShaftMsg$.editInt),
  ];
};
