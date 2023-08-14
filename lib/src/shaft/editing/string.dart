import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/sharing_box.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/inner_state.dart';
import 'package:mhu_dart_ide/src/screen/notification.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../bx/boxed.dart';
import '../../keyboard.dart';
import '../../op.dart';
import '../../theme.dart';

part 'string.g.has.dart';

part 'string.g.compose.dart';

@Has()
typedef MaxStringLength = int?;

@Has()
typedef SubmitValue<T> = void Function(T value);

@Has()
typedef ParseString<T> = ValidatingFunction<String, T>;

@Compose()
abstract class StringParsingBits<T>
    implements HasMaxStringLength, HasSubmitValue<T>, HasParseString<T> {
  static StringParsingBits<String> stringType({
    required SubmitValue<String> submitValue,
  }) {
    return ComposedStringParsingBits(
      submitValue: submitValue,
      parseString: ValidationSuccessImpl.new,
    );
  }

  static final _maxIntLength = 0x7FFFFFFF.toString().length;

  static StringParsingBits<int> intType({
    required SubmitValue<int> submitValue,
  }) {
    return ComposedStringParsingBits(
      submitValue: submitValue,
      parseString: parseIntValidatingFunction,
      maxStringLength: _maxIntLength,
    );
  }
}

SharingBoxes editScalarAsStringSharingBoxes<T>({
  required SizedShaftBuilderBits sizedBits,
  required StringParsingBits<T> stringParsingBits,
}) {
  final SizedShaftBuilderBits(
    shaftCalcChain: ShaftCalcChain(
      :isFocused,
    ),
  ) = sizedBits;

  if (isFocused) {
    return [
      focusedStringEditorSharingBox(
        sizedBits: sizedBits,
        stringParsingBits: stringParsingBits,
      ),
    ];
  } else {
    return unfocusedStringEditSharingBoxes(
      sizedBits: sizedBits,
    );
  }
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

void Function(InnerStateFw innerStateFw) createStringEditorKeyListenerAccess({
  required OpBuilder opBuilder,
  required void Function(InnerStateFw innerStateFw) onEnter,
  required void Function(InnerStateFw innerStateFw) onEscape,
  required bool Function(String text, String character) acceptCharacter,
}) {
  ShortcutKeyListener keyListener = (key) {};

  opBuilder.addKeyListener((key) {
    keyListener(key);
  });
  return (innerStateFw) {
    keyListener = (key) {
      switch (key) {
        case ShortcutKey.enter:
          onEnter(innerStateFw);
          return;
        case ShortcutKey.escape:
          onEscape(innerStateFw);
          return;
        default:
      }
      innerStateFw.update((innerState) {
        innerState ??= MdiInnerStateMsg.getDefault();
        return innerState.deepRebuild((message) {
          final text = message.stringEdit.text;
          switch (key) {
            case ShortcutKey.backspace:
              final length = text.length;
              if (length > 0) {
                message.ensureStringEdit().text = text.substring(0, length - 1);
              }
            case CharacterShortcutKey(:final character):
              if (acceptCharacter(text, character)) {
                message.ensureStringEdit().text = "$text$character";
              }

            case _:
          }
        });
      });
    };
  };
}

SharingBox stringEditorSharingBoxFromGridSizeBuilder({
  required SizedShaftBuilderBits sizedBits,
  required double intrinsicHeight,
  required Widget Function(
    GridSize gridSize,
  ) builder,
}) {
  return ComposedSharingBox(
    intrinsicDimension: intrinsicHeight,
    dimensionBxBuilder: (height) {
      final widgetSize = sizedBits.size.withHeight(height);
      final gridSize =
          sizedBits.themeCalc.stringTextStyle.maxGridSize(widgetSize);

      final widget = builder(gridSize);

      return Bx.leaf(
        size: widgetSize,
        widget: widget,
      );
    },
  );
}

SharingBox focusedStringEditorSharingBox<T>({
  required SizedShaftBuilderBits sizedBits,
  required StringParsingBits<T> stringParsingBits,
}) {
  final SizedShaftBuilderBits(
    themeCalc: ThemeCalc(
      :textCursorThickness,
      :stringTextStyle,
    ),
    shaftCalcChain: ShaftCalcChain(
      :isFocused,
    ),
    :opBuilder,
  ) = sizedBits;

  final StringParsingBits(
    :maxStringLength,
    :parseString,
    :submitValue,
  ) = stringParsingBits;

  final availableWidth = sizedBits.width - textCursorThickness;
  final intrinsicHeight = maxStringLength == null
      ? sizedBits.height
      : stringTextStyle.calculateIntrinsicHeight(
          stringLength: maxStringLength,
          width: availableWidth,
        );

  return stringEditorSharingBoxFromGridSizeBuilder(
    sizedBits: sizedBits,
    intrinsicHeight: intrinsicHeight,
    builder: (gridSize) {
      return sizedBits.innerStateWidgetVoid(
        access: createStringEditorKeyListenerAccess(
          opBuilder: opBuilder,
          onEscape: (innerStateFw) {
            sizedBits.fwUpdateGroup.run(() {
              sizedBits.shaftCalcChain.shaftMsgFu.update((shaftMsg) {
                shaftMsg.innerState = innerStateFw.read()!;
              });
              sizedBits.clearFocusedShaft();
            });
          },
          onEnter: (innerStateFw) {
            final innerState = innerStateFw.read()!;
            final text = innerState.stringEdit.text;

            final parseResult = parseString(text);

            switch (parseResult) {
              case ValidationSuccess<T>(:final value):
                sizedBits.fwUpdateGroup.run(() {
                  sizedBits.shaftCalcChain.shaftMsgFu.update((shaftMsg) {
                    shaftMsg.innerState = innerState;
                  });
                  submitValue(value);
                  sizedBits.clearFocusedShaft();
                  // sizedBits.closeShaft();
                });
              case ValidationFailure<T>():
                sizedBits.showNotifications(
                  parseResult.validationFailureMessages,
                );
            }
          },
          acceptCharacter: (text, character) =>
              character == " " ||
              !TextLayoutMetrics.isWhitespace(character.codeUnitAt(0)),
        ),
        builder: (innerState, update) {
          final text = innerState.stringEdit.text;

          return stringWidgetWithCursor(
            text: text,
            gridSize: gridSize,
            themeCalc: sizedBits.themeCalc,
            isFocused: isFocused,
          );
        },
      );
    },
  );
}

SharingBoxes unfocusedStringEditSharingBoxes({
  required SizedShaftBuilderBits sizedBits,
}) {
  final SizedShaftBuilderBits(
    themeCalc: ThemeCalc(
      :textCursorThickness,
      :stringTextStyle,
    ),
  ) = sizedBits;
  final availableWidth = sizedBits.width - textCursorThickness;

  final text = sizedBits.shaftMsg.innerState.stringEdit.text;
  final intrinsicHeight = stringTextStyle.calculateIntrinsicHeight(
    stringLength: text.length,
    width: availableWidth,
  );
  final stringSharingBox = stringEditorSharingBoxFromGridSizeBuilder(
    sizedBits: sizedBits,
    intrinsicHeight: intrinsicHeight,
    builder: (gridSize) {
      return stringWidgetWithCursor(
        text: text,
        gridSize: gridSize,
        themeCalc: sizedBits.themeCalc,
        isFocused: false,
      );
    },
  );

  return [
    ...sizedBits.menu(
      items: [
        MenuItem(
          label: "Focus",
          callback: sizedBits.requestFocus,
        ),
      ],
    ),
    stringSharingBox,
  ];
}
