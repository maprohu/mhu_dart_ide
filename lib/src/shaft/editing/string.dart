import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/bx/share.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/inner_state.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../bx/boxed.dart';
import '../../theme.dart';

// part 'string.g.has.dart';
part 'string.g.compose.dart';

@Compose()
abstract class EditScalarStringBits
    implements
        EditScalarShaftBits<String>,
        EditingShaftContentBits<String>,
        EditingShaftLabeledContentBits<String> {
  static const headerLabel = "Edit String";

  static EditScalarStringBits of({
    required EditScalarShaftBits<String> editScalarShaftBits,
  }) {
    return ComposedEditScalarStringBits.editScalarShaftBits(
      editScalarShaftBits: editScalarShaftBits,
      buildShaftContent: editScalarStringBuildShaftContent(),
      shaftHeaderLabel: headerLabel,
    );
  }
}

BuildShaftContent editScalarStringBuildShaftContent({
  int? maxStringLength,
}) {
  return (sizedBits) {
    final SizedShaftBuilderBits(
      themeCalc: ThemeCalc(
        :textCursorThickness,
        :stringTextStyle,
      ),
      shaftCalcChain: ShaftCalcChain(
        :isFocused,
        :shaftIndexFromLeft,
      ),
      :stateFw,
    ) = sizedBits;

    final availableWidth = sizedBits.width - textCursorThickness;

    final columnCount = stringTextStyle
        .maxGridSize(
          sizedBits.size.withWidth(availableWidth),
        )
        .columnCount;

    double calcIntrinsicHeight(int? stringLength) {
      if (stringLength == null) {
        return sizedBits.height;
      } else {
        final intrinsicRowCount = (stringLength - 1) ~/ columnCount + 1;

        return stringTextStyle.height * intrinsicRowCount;
      }
    }

    final intrinsicHeight = calcIntrinsicHeight(maxStringLength);

    final intrinsicSize = sizedBits.size.withHeight(intrinsicHeight);

    late final editorBx = ComposedSharingBx(
      intrinsicDimension: intrinsicHeight,
      dimensionBxBuilder: (height) {
        final widgetSize = sizedBits.size.withHeight(height);
        final gridSize = stringTextStyle.maxGridSize(widgetSize);

        final widget = sizedBits.innerStateWidgetVoid(
          builder: (innerState, update) {
            final text = innerState.editString.text;

            return stringWidgetWithCursor(
              text: text,
              gridSize: gridSize,
              themeCalc: sizedBits.themeCalc,
              isFocused: isFocused,
            );
          },
        );

        return Bx.leaf(size: widgetSize, widget: widget);
      },
    );

    if (!isFocused) {
      return [
        ...sizedBits.menu(
          items: [
            MenuItem(
              label: "Focus",
              callback: () {
                stateFw.deepRebuild(
                  (state) {
                    state.ensureFocusedShaft().indexFromLeft =
                        shaftIndexFromLeft;
                  },
                );
              },
            ),
          ],
        ),
        editorBx,
      ];
    } else {
      sizedBits.opBuilder.registerClearFocusOnEscape();
      return const [];
    }
  };
}

Widget stringWidgetWithCursor({
  required String text,
  required GridSize gridSize,
  required ThemeCalc themeCalc,
  required bool isFocused,
}) {
  final GridSize(
    :cellCount,
  ) = gridSize;

  final ThemeCalc(
    :textCursorThickness,
    :stringTextStyle,
  ) = themeCalc;

  final textLength = text.length;

  final clipCount = textLength - cellCount;
  final isClipped = clipCount > 0;

  final textAfterClipping = isClipped ? text.substring(clipCount) : text;

  final lineSlices = textAfterClipping.slices(gridSize.columnCount);

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
          themeCalc: themeCalc,
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
              color: themeCalc.textCursorColor,
            ),
          ),
        ),
      ),
    ],
  );
}
