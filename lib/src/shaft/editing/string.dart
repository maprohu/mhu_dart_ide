import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/bx/share.dart';
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

// part 'string.g.has.dart';
part 'string.g.compose.dart';

@Compose()
abstract class EditScalarStringBits
    implements
        EditScalarShaftBits<String>,
        EditingShaftContentBits<String>,
        EditingShaftLabeledContentBits<String> {
  static const headerLabel = "Edit String";

  static EditingShaftLabeledContentBits create({
    required EditScalarShaftBits<String> editScalarShaftBits,
  }) {
    return ComposedEditScalarStringBits.editScalarShaftBits(
      editScalarShaftBits: editScalarShaftBits,
      buildShaftContent: editScalarAsStringBuildShaftContent(
        onSubmit: editScalarShaftBits.editingFw.set,
        parser: (input) => ValidationSuccessImpl(input),
        textAttribute: MdiInnerStateMsg$.editString.thenReadWrite(
          MdiInnerEditStringMsg$.text,
        ),
      ),
      shaftHeaderLabel: headerLabel,
    );
  }
}

// BuildShaftContent editScalarStringBuildShaftContent({
//   int? maxStringLength,
//   required void Function(String string) onSubmit,
// }) {
//   return (sizedBits) {
//     final SizedShaftBuilderBits(
//       themeCalc: ThemeCalc(
//         :textCursorThickness,
//         :stringTextStyle,
//       ),
//       shaftCalcChain: ShaftCalcChain(
//         :isFocused,
//         :shaftIndexFromLeft,
//       ),
//       :stateFw,
//       :opBuilder,
//     ) = sizedBits;
//
//     final availableWidth = sizedBits.width - textCursorThickness;
//
//     SharingBx editorSharingBxFromWidget({
//       required double intrinsicHeight,
//       required Widget Function(
//         GridSize gridSize,
//       ) builder,
//     }) {
//       return ComposedSharingBx(
//         intrinsicDimension: intrinsicHeight,
//         dimensionBxBuilder: (height) {
//           final widgetSize = sizedBits.size.withHeight(height);
//           final gridSize = stringTextStyle.maxGridSize(widgetSize);
//
//           final widget = builder(gridSize);
//
//           return Bx.leaf(
//             size: widgetSize,
//             widget: widget,
//           );
//         },
//       );
//     }
//
//     SharingBx editorBxNotFocused() {
//       final text = sizedBits.shaftMsg.editScalar.innerState.editString.text;
//       final intrinsicHeight = stringTextStyle.calculateIntrinsicHeight(
//         stringLength: text.length,
//         width: availableWidth,
//       );
//       return editorSharingBxFromWidget(
//         intrinsicHeight: intrinsicHeight,
//         builder: (gridSize) {
//           return stringWidgetWithCursor(
//             text: text,
//             gridSize: gridSize,
//             themeCalc: sizedBits.themeCalc,
//             isFocused: false,
//           );
//         },
//       );
//     }
//
//     SharingBx editorBxFocused() {
//       final intrinsicHeight = maxStringLength == null
//           ? sizedBits.height
//           : stringTextStyle.calculateIntrinsicHeight(
//               stringLength: maxStringLength,
//               width: availableWidth,
//             );
//       return editorSharingBxFromWidget(
//         intrinsicHeight: intrinsicHeight,
//         builder: (gridSize) {
//           return sizedBits.innerStateWidgetVoid(
//             access: createStringEditorKeyListenerAccess(
//               opBuilder: opBuilder,
//               onEscape: (innerStateFw) {
//                 sizedBits.fwUpdateGroup.run(() {
//                   sizedBits.shaftCalcChain.shaftMsgFu.update((shaftMsg) {
//                     shaftMsg.editScalar.innerState = innerStateFw.read()!;
//                   });
//                   sizedBits.clearFocusedShaft();
//                 });
//               },
//               onEnter: (innerStateFw) {
//                 sizedBits.fwUpdateGroup.run(() {
//                   final text = innerStateFw.read()!.editString.text;
//                   onSubmit(text);
//                   sizedBits.clearFocusedShaft();
//                   sizedBits.closeShaft();
//                 });
//               },
//               textAttribute: MdiInnerStateMsg$.editString.thenReadWrite(
//                 MdiInnerEditStringMsg$.text,
//               ),
//               acceptCharacter: (text, character) =>
//                   character == " " ||
//                   !TextLayoutMetrics.isWhitespace(character.codeUnitAt(0)),
//             ),
//             builder: (innerState, update) {
//               final text = innerState.editString.text;
//
//               return stringWidgetWithCursor(
//                 text: text,
//                 gridSize: gridSize,
//                 themeCalc: sizedBits.themeCalc,
//                 isFocused: isFocused,
//               );
//             },
//           );
//         },
//       );
//     }
//
//     if (isFocused) {
//       return [
//         editorBxFocused(),
//       ];
//     } else {
//       return [
//         ...sizedBits.menu(
//           items: [
//             MenuItem(
//               label: "Focus",
//               callback: () {
//                 stateFw.deepRebuild(
//                   (state) {
//                     state.ensureFocusedShaft().indexFromLeft =
//                         shaftIndexFromLeft;
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//         editorBxNotFocused(),
//       ];
//     }
//   };
// }

BuildShaftContent editScalarAsStringBuildShaftContent<T>({
  int? maxStringLength,
  required void Function(T value) onSubmit,
  required ValidatingFunction<String, T> parser,
  required ReadWriteAttribute<MdiInnerStateMsg, String> textAttribute,
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
      :opBuilder,
    ) = sizedBits;

    final availableWidth = sizedBits.width - textCursorThickness;

    SharingBx editorSharingBxFromWidget({
      required double intrinsicHeight,
      required Widget Function(
        GridSize gridSize,
      ) builder,
    }) {
      return ComposedSharingBx(
        intrinsicDimension: intrinsicHeight,
        dimensionBxBuilder: (height) {
          final widgetSize = sizedBits.size.withHeight(height);
          final gridSize = stringTextStyle.maxGridSize(widgetSize);

          final widget = builder(gridSize);

          return Bx.leaf(
            size: widgetSize,
            widget: widget,
          );
        },
      );
    }

    SharingBx editorBxNotFocused() {
      final text = sizedBits.shaftMsg.editScalar.innerState.editString.text;
      final intrinsicHeight = stringTextStyle.calculateIntrinsicHeight(
        stringLength: text.length,
        width: availableWidth,
      );
      return editorSharingBxFromWidget(
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
    }

    SharingBx editorBxFocused() {
      final intrinsicHeight = maxStringLength == null
          ? sizedBits.height
          : stringTextStyle.calculateIntrinsicHeight(
              stringLength: maxStringLength,
              width: availableWidth,
            );
      return editorSharingBxFromWidget(
        intrinsicHeight: intrinsicHeight,
        builder: (gridSize) {
          return sizedBits.innerStateWidgetVoid(
            access: createStringEditorKeyListenerAccess(
              opBuilder: opBuilder,
              onEscape: (innerStateFw) {
                sizedBits.fwUpdateGroup.run(() {
                  sizedBits.shaftCalcChain.shaftMsgFu.update((shaftMsg) {
                    shaftMsg.editScalar.innerState = innerStateFw.read()!;
                  });
                  sizedBits.clearFocusedShaft();
                });
              },
              onEnter: (innerStateFw) {
                final text = innerStateFw.read()!.editInt.text;

                final parseResult = parser(text);

                switch (parseResult) {
                  case ValidationSuccess<T>():
                    sizedBits.fwUpdateGroup.run(() {
                      onSubmit(parseResult.validationSuccessValue);
                      sizedBits.clearFocusedShaft();
                      sizedBits.closeShaft();
                    });
                  case ValidationFailure<T>():
                    sizedBits.showNotifications(
                      parseResult.validationFailureMessages,
                    );
                }
              },
              textAttribute: textAttribute,
              acceptCharacter: (text, character) =>
                  character == " " ||
                  !TextLayoutMetrics.isWhitespace(character.codeUnitAt(0)),
            ),
            builder: (innerState, update) {
              final text = textAttribute.readAttribute(innerState);

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

    if (isFocused) {
      return [
        editorBxFocused(),
      ];
    } else {
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
        editorBxNotFocused(),
      ];
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

void Function(InnerStateFw innerStateFw) createStringEditorKeyListenerAccess({
  required OpBuilder opBuilder,
  required void Function(InnerStateFw innerStateFw) onEnter,
  required void Function(InnerStateFw innerStateFw) onEscape,
  required ReadWriteAttribute<MdiInnerStateMsg, String> textAttribute,
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
          final text = textAttribute.readAttribute(message);
          switch (key) {
            case ShortcutKey.backspace:
              final length = text.length;
              if (length > 0) {
                textAttribute.writeAttribute(
                  message,
                  text.substring(0, length - 1),
                );
              }
            case CharacterShortcutKey(:final character):
              if (acceptCharacter(text, character)) {
                textAttribute.writeAttribute(
                  message,
                  "$text$character",
                );
              }

            case _:
          }
        });
      });
    };
  };
}
