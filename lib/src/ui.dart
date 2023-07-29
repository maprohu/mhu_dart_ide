import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';

part 'ui.freezed.dart';

@freezedStruct
class UiBuilder with _$UiBuilder {
  UiBuilder._();

  factory UiBuilder({
    required OpReg opReg,
    required TextBuilder itemText,
    required TextBuilder headerText,
    required TextBuilder keysText,
  }) = _UiBuilder;
}

extension UiBuilderX on UiBuilder {
  UiBuilder withOpReg(OpReg opReg) => copyWith(opReg: opReg);

  SizedWidget opIcon({
    required HasSizedWidget icon,
}) {
    sizedOpIcon(icon: icon, keys: keys, ui: ui)
  }
}
