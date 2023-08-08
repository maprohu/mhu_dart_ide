import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

part 'editing.g.has.dart';

@Has()
typedef EditingFw<T> = Fw<T>;

abstract class EditingShaftContentBits<T>
    implements ShaftContentBits, HasEditingFw<T> {}
