import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';

import 'op.dart';
import 'widgets/sized.dart' as sized;

part 'ui.freezed.dart';

@freezedStruct
class UiBuilder with _$UiBuilder {
  UiBuilder._();

  factory UiBuilder({
    required OpReg opReg,
    required TextBuilder itemText,
    required TextBuilder headerText,
    required TextBuilder keysText,
    required TextBuilder keysPressedText,
  }) = _UiBuilder;
}

extension UiBuilderX on UiBuilder {
  UiBuilder withOpReg(OpReg opReg) => copyWith(opReg: opReg);

  HasSizedWidget sizedKeys({
    required Keys? keys,
    required int pressedCount,
  }) =>
      sized.sizedKeys(
        keys: keys,
        ui: this,
        pressedCount: pressedCount,
      );

  HasSizedWidget sizedOpIcon({
    required HasSizedWidget icon,
    required Keys? keys,
    required int pressedCount,
  }) =>
      sized.sizedOpIcon(
        icon: icon,
        keys: keys,
        ui: this,
        pressedCount: pressedCount,
      );
}
