import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/bx/share.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';
import 'package:mhu_dart_ide/src/isar.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/inner_state.dart';
import 'package:mhu_dart_ide/src/screen/notification.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_ide/src/shaft/editing/string.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/widgets/async.dart';
import 'package:mhu_dart_ide/src/widgets/busy.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';
import 'package:protobuf/protobuf.dart';

import '../../bx/boxed.dart';
import '../../bx/padding.dart';
import '../../keyboard.dart';

List<MenuItem> intEditOptions({
  required ShaftBuilderBits shaftBuilderBits,
  required int? currentValue,
}) {
  return [
    shaftBuilderBits.openerField(
      MdiShaftMsg$.editScalar,
      before: (shaftMsg) {
        shaftBuilderBits.accessInnerStateRight((innerStateFw) async {
          innerStateFw.value = MdiInnerStateMsg$.create(
            editInt: MdiInnerEditIntMsg$.create(
              text: currentValue?.let((v) => v.toString()) ?? "",
            ),
          )..freeze();
        });
      },
    ),
  ];
}

final _maxLength = 0x7FFFFFFF.toString().length;

ShaftCalc editIntShaftCalc(ShaftCalcBuildBits shaftCalcBuildBits) {
  final HasEditingFw(
    :editingFw,
  ) = shaftCalcBuildBits.leftCalc as HasEditingFw;

  return ComposedShaftCalc.shaftCalcBuildBits(
    shaftCalcBuildBits: shaftCalcBuildBits,
    shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
    buildShaftContent: (sizedBits) {
      final SizedShaftBuilderBits(
        themeCalc: ThemeCalc(
          :textCursorThickness,
          :stringTextStyle,
        ),
      ) = sizedBits;

      final availableWidth = sizedBits.width - textCursorThickness;

      final columnCount = stringTextStyle
          .maxGridSize(
            sizedBits.size.withWidth(availableWidth),
          )
          .columnCount;

      final intrinsicRowCount = (_maxLength - 1) ~/ columnCount + 1;

      final intrinsicHeight = stringTextStyle.height * intrinsicRowCount;

      return ComposedSharingBx(
        intrinsicDimension: intrinsicHeight,
        dimensionBxBuilder: (height) {
          final bxBits = sizedBits.withHeight(height);

          final bxSize = bxBits.size;

          final widgetSize = Size(
            availableWidth,
            height,
          );

          final gridSize = stringTextStyle.maxGridSize(widgetSize);

          final cellCount = gridSize.cellCount;

          final gridPixelSize =
              gridSize.sizeFrom(cellSize: stringTextStyle.size);

          ShortcutKeyListener keyListener = (key) {};

          sizedBits.opBuilder.addKeyListener((key) {
            keyListener(key);
          });

          final gridSizeWithCursorMargin = gridPixelSize
              .withWidth(gridPixelSize.width + textCursorThickness);

          final widget = sizedBits.innerStateWidgetVoid(
            access: (fv) {
              keyListener = (key) {
                if (key == ShortcutKey.enter) {
                  try {
                    sizedBits.fwUpdateGroup.run(() {
                      fv.read()?.editInt.text.let(int.parse).let(editingFw.set);
                      sizedBits.closeShaft();
                    });
                  } catch (e) {
                    sizedBits.showNotification(e.toString());
                  }
                  return;
                }
                fv.update((innerState) {
                  innerState ??= MdiInnerStateMsg.getDefault();
                  return innerState.deepRebuild((message) {
                    final editInt = message.ensureEditInt();
                    switch (key) {
                      case ShortcutKey.backspace:
                        final length = editInt.text.length;
                        if (length > 0) {
                          editInt.text = editInt.text.substring(0, length - 1);
                        }
                      case CharacterShortcutKey():
                        editInt.text = "${editInt.text}${key.character}";
                      case _:
                    }
                  });
                });
              };
            },
            builder: (innerState, update) {
              final text = innerState.editInt.text;

              return stringWidgetWithCursor(
                text: text,
                gridSize: gridSize,
                themeCalc: sizedBits.themeCalc,
                isFocused: false,
              );
            },
          );

          ;

          return Bx.pad(
            padding: Paddings.topLeft(
              outer: widgetSize,
              inner: gridPixelSize,
            ),
            child: Bx.leaf(
              size: gridSizeWithCursorMargin,
              widget: widget,
            ),
            size: bxSize,
          );
        },
      ).toSingleElementIterable;
    },
  );
}
