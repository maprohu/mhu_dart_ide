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
import 'package:mhu_dart_ide/src/screen/notification.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
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
      MdiShaftMsg$.editInt,
      before: (shaftMsg) {
        shaftBuilderBits.accessInnerState(
          shaftBuilderBits.shaftCalcChain.shaftIndexFromLeft + 1,
          (innerStateFw) async {
            innerStateFw.value = MdiInnerStateMsg$.create(
              editInt: MdiInnerEditIntMsg$.create(
                text: currentValue?.let((v) => v.toString()) ?? "",
              ),
            )..freeze();
          },
        );
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
          final widget = futureBuilderNull(
            future: sizedBits.accessInnerState(
              sizedBits.shaftCalcChain.shaftIndexFromLeft,
              (fv) async {
                keyListener = (key) {
                  if (key == ShortcutKey.enter) {
                    try {
                      fv.read()?.editInt.text.let(int.parse).let(editingFw.set);
                      sizedBits.closeShaft();
                    } catch (e) {
                      sizedBits.showNotification(e.toString());
                    }
                  }
                  fv.update((innerState) {
                    innerState ??= MdiInnerStateMsg.getDefault();
                    return innerState.deepRebuild((message) {
                      final editInt = message.ensureEditInt();
                      final display = key.display;
                      if (key == ShortcutKey.backspace) {
                        final length = editInt.text.length;
                        if (length > 0) {
                          editInt.text = editInt.text.substring(0, length - 1);
                        }
                      } else if (isDigit(display, 0)) {
                        editInt.text = "${editInt.text}$display";
                      }
                    });
                  });
                };

                return fv;
              },
            ),
            builder: (context, innerStateFw) {
              return flcFrr(() {
                final innerState = innerStateFw();
                if (innerState == null) {
                  return mdiBusyWidget;
                }
                final text = innerState.editInt.text;

                final textLength = text.length;

                final clipCount = textLength - cellCount;
                final isClipped = clipCount > 0;

                final textAfterClipping =
                    isClipped ? text.substring(clipCount) : text;

                final lineSlices =
                    textAfterClipping.slices(gridSize.columnCount);

                final lines = lineSlices.isEmpty ? const [""] : lineSlices;

                final cursorLineIndex = lines.length - 1;
                final cursorColumnIndex = lines.last.length;

                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: textCursorThickness / 2,
                      ),
                      child: stringLinesWidget(
                        lines: lines,
                        isClipped: isClipped,
                        themeCalc: sizedBits.themeCalc,
                      ),
                    ),
                    Positioned(
                      left: cursorColumnIndex * stringTextStyle.width,
                      top: cursorLineIndex * stringTextStyle.height,
                      child: SizedBox(
                        width: textCursorThickness,
                        height: stringTextStyle.height,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: sizedBits.themeCalc.textCursorColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
            },
          );

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
      );
    },
  );
}
