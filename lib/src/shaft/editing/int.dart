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
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/widgets/async.dart';
import 'package:mhu_dart_ide/src/widgets/busy.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../bx/boxed.dart';
import '../../bx/padding.dart';

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

ShaftCalc editIntShaftCalc(ShaftCalcBuildBits shaftCalcBuildBits) {
  return ComposedShaftCalc.shaftCalcBuildBits(
    shaftCalcBuildBits: shaftCalcBuildBits,
    shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
    buildShaftContent: (sizedBits) {
      return ComposedSharingBx(
        intrinsicDimension: sizedBits.height,
        dimensionBxBuilder: (height) {
          final SizedShaftBuilderBits(
            themeCalc: ThemeCalc(
              :textCursorThickness,
              :stringTextStyle,
            ),
          ) = sizedBits;

          final bxBits = sizedBits.withHeight(height);

          final bxSize = bxBits.size;

          final availableWidth = bxSize.width - textCursorThickness;

          final widgetSize = Size(
            availableWidth,
            height,
          );

          final gridSize = stringTextStyle.maxGridSize(widgetSize);

          final cellCount = gridSize.cellCount;

          final gridPixelSize =
              gridSize.sizeFrom(cellSize: stringTextStyle.size);

          ShortcutKeyListener keyListener = (key) {

          };

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
                  fv.update((innerState) {

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

                final clipCount = text.length - cellCount;
                final isClipped = clipCount > 0;

                final textAfterClipping =
                    isClipped ? text.substring(clipCount) : text;

                final lines = textAfterClipping.slices(gridSize.columnCount);

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
