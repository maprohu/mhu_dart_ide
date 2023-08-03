import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';
import 'package:mhu_dart_ide/src/bx/boxed.dart';
import 'package:mhu_dart_ide/src/bx/shortcut.dart';
import 'package:mhu_dart_ide/src/bx/shaft.dart';
import 'package:mhu_dart_ide/src/generated/mhu_dart_ide.pb.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/main_menu.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../../../proto.dart';
import '../../../../proto.dart';
import '../../../../proto.dart';
import '../../../bx/menu.dart';

ShaftBuilder mdiPfeMapFieldShaftBuilder({
  required MapFieldAccess access,
  required Mfw mfw,
}) {
  final ffu = access.fu(mfw);

  return (headerBits, contentBits) {
    return ShaftParts(
      header: headerBits.fillLeft(
        left: (sizedBits) => sizedBits.headerText.centerLeft(
          access.fieldKey.calc.protoName,
        ),
        right: headerBits.shaftBits.shortcut(() {}),
      ),
      content: contentBits.fill(),
    );
  };
}

class MapFieldOptions extends ConcreteFieldOptions {
  final MapFieldAccess access;

  MapFieldOptions(super.shaftCalc, this.access);

  @override
  List<MenuItem> options(ShaftBuilderBits shaftBits) {
    return [
      shaftBits.openerField(MdiShaftMsg$.newMapItem),
    ];
  }
}

class NewMapItemShaftCalc extends ShaftCalc {
  NewMapItemShaftCalc(super.shaftCalcChain);

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    return sizedBits.menu(items: [
      sizedBits.openerField(MdiShaftMsg$.entryKey),
      sizedBits.openerField(MdiShaftMsg$.entryValue),
      MenuItem(
        label: "Save Entry",
        callback: () {},
      ),
    ]);
  }
}

class EntryKeyShaftCalc extends ShaftCalc {
  EntryKeyShaftCalc(super.shaftCalcChain)
      : super.access(access: MdiShaftMsg$.entryKey);

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    return sizedBits.fill();
  }
}

class EntryValueShaftCalc extends ShaftCalc {
  EntryValueShaftCalc(super.shaftCalcChain)
      : super.access(access: MdiShaftMsg$.entryValue);

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    return sizedBits.fill();
  }

}
