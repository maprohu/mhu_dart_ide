import 'package:flutter/services.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/builder/text.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/proto.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/editing/string.dart';
import 'package:mhu_dart_ide/src/shaft/string.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

part 'edit_scalar.g.has.dart';

part 'edit_scalar.g.compose.dart';

@Has()
@Compose()
abstract class EditScalarShaftRight {}

@Compose()
abstract class EditScalarShaftMerge
    implements HasShaftHeaderLabel, ShaftContentBits, HasShaftInitState {}

@Compose()
abstract class EditScalarShaft
    implements
        ShaftCalcBuildBits,
        EditScalarShaftRight,
        EditScalarShaftMerge,
        ShaftCalc {
  static EditScalarShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final left = shaftCalcBuildBits.leftCalc as HasEditingBits;

    final scalarEditingBits = left.editingBits as ScalarEditingBits;

    return scalarEditingBits.scalarEditingBitsGeneric(<T>(scalarEditingBits) {
      final shaftRight = ComposedEditScalarShaftRight();

      final ScalarDataType sdt = scalarEditingBits.scalarDataType;
      final merge = switch (sdt) {
        StringDataType() => stringType(
            shaftCalcBuildBits: shaftCalcBuildBits,
            scalarEditingBits: scalarEditingBits,
          ),
        CoreIntDataType() => ComposedEditScalarShaftMerge(
            shaftHeaderLabel: "Edit Int",
            buildShaftContent: (sizedBits) {
              throw "todo";
            },
          ),
        final other => throw other,
      };

      return ComposedEditScalarShaft.merge$(
        shaftCalcBuildBits: shaftCalcBuildBits,
        editScalarShaftMerge: merge,
        editScalarShaftRight: shaftRight,
        shaftAutoFocus: true,
      );
    });
  }

  static const label = "Edit String";

  static void _pasteFromClipboard(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) async {
    final string = await getStringFromClipboard();
    final innerState = stringEditInnerState(string ?? "");
    shaftCalcBuildBits.accessOwnInnerState((innerStateFw) {
      innerStateFw.value = innerState;
    });
    shaftCalcBuildBits.fwUpdateGroup.run(() {
      shaftCalcBuildBits.shaftCalcChain.shaftUpdateValue.updateValue(
        (shaftMsg) {
          shaftMsg.innerState = innerState;
        },
      );
      shaftCalcBuildBits.clearFocusedShaft();
    });
  }

  static MdiInnerStateMsg stringEditInnerState(String text) {
    final result = MdiInnerStateMsg();
    result.ensureStringEdit()
      ..text = text
      ..cursorPosition = text.length;
    return result..freeze();
  }

  static EditScalarShaftMerge stringType<T>({
    required ShaftCalcBuildBits shaftCalcBuildBits,
    required ScalarEditingBits<T> scalarEditingBits,
  }) {
    if (shaftCalcBuildBits.innerState.stringEdit.pasting) {
      return ComposedEditScalarShaftMerge(
        shaftHeaderLabel: label,
        buildShaftContent: (sizedBits) {
          return sizedBits.itemText
              .left("Pasting from Clipboard...")
              .toSharingBoxes;
        },
        shaftInitState: () {
          _pasteFromClipboard(shaftCalcBuildBits);
          return MdiInnerStateMsg.getDefault();
        },
      );
    } else {
      final bits = scalarEditingBits as ScalarEditingBits<String>;
      final currentSavedValue = bits.watchValue();
      final stringParsingBits = StringParsingBits.stringType(
        submitValue: (value) {
          bits.writeValue(value);
          shaftCalcBuildBits.closeShaft();
        },
      );
      final currentParsedValue = stringParsingBits.parseString(
        shaftCalcBuildBits.innerState.stringEdit.text,
      );

      final saveItems = switch (currentParsedValue) {
        ValidationSuccessImpl(value: final parsedValue) =>
          parsedValue != currentSavedValue
              ? <MenuItem>[
                  MenuItem(
                    label: "Save and Close",
                    callback: () {
                      shaftCalcBuildBits.txn(() {
                        bits.writeValue(parsedValue);
                        shaftCalcBuildBits.closeShaft();
                      });
                    },
                  ),
                  MenuItem(
                    label: "Discard",
                    callback: shaftCalcBuildBits.closeShaft,
                  ),
                ]
              : [],
        _ => [],
      };

      return ComposedEditScalarShaftMerge(
        shaftHeaderLabel: label,
        buildShaftContent: (sizedBits) {
          return editScalarAsStringSharingBoxes(
            sizedBits: sizedBits,
            stringParsingBits: stringParsingBits,
            extraBoxes: sizedBits.menu([
              ...saveItems,
              MenuItem(
                label: "Paste from Clipboard",
                callback: () {
                  shaftCalcBuildBits.txn(() {
                    shaftCalcBuildBits.updateShaftMsg((shaftMsg) {
                      shaftMsg.ensureInnerState().ensureStringEdit().pasting =
                          true;
                    });
                    shaftCalcBuildBits.requestFocus();
                  });
                  _pasteFromClipboard(shaftCalcBuildBits);
                },
              ),
            ]),
          );
        },
        shaftInitState: () {
          final text = bits.readValue() ?? "";
          return MdiInnerStateMsg()
            ..ensureStringEdit().text = text
            ..freeze();
        },
      );
    }
  }
}
