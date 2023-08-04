import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';
import 'package:mhu_dart_ide/src/bx/boxed.dart';
import 'package:mhu_dart_ide/src/bx/shortcut.dart';
import 'package:mhu_dart_ide/src/bx/shaft.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/editing.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../../../proto.dart';
import '../../../bx/menu.dart';
import '../../../screen/options.dart';

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

class MapFieldOptions extends ConcreteFieldOptions with HasMapKeyVariant {
  final MapFieldAccess access;

  MapFieldOptions(super.shaftCalc, this.access);

  @override
  Options options(ShaftBuilderBits shaftBits) {
    return [
      shaftBits.openerField(MdiShaftMsg$.newMapItem),
    ];
  }

  @override
  late final mapKeyVariant = switch (access.defaultMapKey) {
    PbIntMapKey() => IntMapKeyVariant(this),
    PbStringMapKey() => StringMapKeyVariant(this),
  };
}

mixin HasMapKeyVariant {
  MapKeyVariant get mapKeyVariant;
}

class NewMapItemShaftCalc extends ShaftCalc
    with ShaftCalcRightOf<PfeConcreteFieldShaftCalc>
    implements HasEditingValue<MdiMapEntryMsg> {
  NewMapItemShaftCalc(super.shaftCalcChain);

  late final mapFieldOptions = typedLeftCalc.fieldOptions as MapFieldOptions;

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

  @override
  late final editingValue = ComposedEditingValue(
    readValue: readValue,
    writeValue: writeValue,
  );
}

class EntryKeyShaftCalc extends ShaftCalc {
  EntryKeyShaftCalc(super.shaftCalcChain)
      : super.access(access: MdiShaftMsg$.entryKey);

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    return sizedBits.fill();
  }

  @override
  List<MenuItem> options(ShaftBuilderBits shaftBits) {}
}

class EntryValueShaftCalc extends ShaftCalc {
  EntryValueShaftCalc(super.shaftCalcChain)
      : super.access(access: MdiShaftMsg$.entryValue);

  @override
  Bx content(SizedShaftBuilderBits sizedBits) {
    return sizedBits.fill();
  }
}

abstract class MapKeyVariant {
  final MapFieldOptions mapFieldOptions;

  MapKeyVariant(this.mapFieldOptions);

  Options options(ShaftBuilderBits shaftBits);
}

class IntMapKeyVariant extends MapKeyVariant {
  IntMapKeyVariant(super.mapFieldOptions);

  @override
  Options options(ShaftBuilderBits shaftBits) {
    return [
      MenuItem(
        label: "Paste From Clipboard",
        callback: () {},
      ),
    ];
  }
}

class StringMapKeyVariant extends MapKeyVariant {
  StringMapKeyVariant(super.mapFieldOptions);

  @override
  Options options(ShaftBuilderBits shaftBits) {
    return [];
  }
}
