import 'package:flutter/material.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/bx/share.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

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

    double calcIntrinsicHeight() {
      if (maxStringLength == null) {
        return sizedBits.height;
      } else {
        final intrinsicRowCount = (maxStringLength - 1) ~/ columnCount + 1;

        return stringTextStyle.height * intrinsicRowCount;
      }
    }

    final intrinsicHeight = calcIntrinsicHeight();

    if (!isFocused) {
      return sizedBits.menu(items: [
        MenuItem(
            label: "Focus",
            callback: () {
              stateFw.deepRebuild((state) {
                state.ensureFocusedShaft().indexFromLeft = shaftIndexFromLeft;
              });
            }),
      ]);
    } else {
      return sizedBits.fillVerticalSharing();
    }
  };
}
