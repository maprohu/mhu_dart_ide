import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/shaft/build_runner.dart';
import 'package:mhu_dart_ide/src/shaft/config.dart';
import 'package:mhu_dart_ide/src/shaft/error.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/widgets/menu.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';

import '../proto.dart';
import 'flex.dart';
import 'screen.dart';
import 'shaft/main_menu.dart';
import 'widgets/boxed.dart';

part 'shaft.freezed.dart';

FlexNode<Bx> mdiColumnFlexNode({
  required NodeBuilderBits nodeBits,
  required double height,
  required MdiShaftMsg column,
}) {
  return FlexNode(
    grow: false,
    builder: (width) {
      return nodeBits.sizedBxFrom(
        width: width,
        height: height,
        builder: (sizedBits) {
          return switch (column.type) {
            MdiShaftMsg_Type$mainMenu(:final value) => mdiMainMenuShaftBx(
                sizedBits: sizedBits,
                value: value,
              ),
            MdiShaftMsg_Type$buildRunner(:final value) =>
              mdiBuildRunnerMenuShaftBx(
                sizedBits: sizedBits,
                value: value,
              ),
            MdiShaftMsg_Type$config(:final value) => mdiConfigMenuShaftBx(
                sizedBits: sizedBits,
                value: value,
              ),
            MdiShaftMsg_Type$pfeConcreteField(:final value) =>
              mdiPfeConcreteFieldShaftBx(
                sizedBits: sizedBits,
                value: value,
              ),
            final other => errorShaftBx(
                sizedBits: sizedBits,
                message: "no shaft: ${column.whichType().name}",
                stackTrace: StackTrace.current,
              )
          };
        },
      );
    },
  );
}

@freezedStruct
class ShaftParts with _$ShaftParts {
  ShaftParts._();

  factory ShaftParts({
    required Bx header,
    required Bx content,
  }) = _ShaftParts;
}

typedef ShaftBuilder = ShaftParts Function(
    SizedNodeBuilderBits headerBits,
    SizedNodeBuilderBits contentBits,
    );

Bx shaftBx({
  required SizedNodeBuilderBits sizedBits,
  required ShaftBuilder builder,
}) {
  final SizedNodeBuilderBits(
    :width,
    :height,
    :themeCalc,
  ) = sizedBits;

  final ThemeCalc(
    :shaftHeaderDividerThickness,
    :shaftHeaderWithDividerHeight,
    :shaftHeaderPadding,
    :shaftHeaderContentHeight,
  ) = themeCalc;

  final headerContentWidth = width - shaftHeaderPadding.horizontal;
  final contentHeight = height - shaftHeaderWithDividerHeight;

  final parts = builder(
    sizedBits.withSize(Size(headerContentWidth, shaftHeaderContentHeight)),
    sizedBits.withSize(Size(width, contentHeight)),
  );

  return Bx.col([
    Bx.pad(
      padding: shaftHeaderPadding,
      child: parts.header,
    ),
    Bx.horizontalDivider(
      thickness: shaftHeaderDividerThickness,
      width: width,
    ),
    parts.content,
  ]);
}

Bx columnHeaderBx({
  required NodeBuilderBits nodeBits,
  required double columnWidth,
  required NodeBuilder content,
  required ThemeCalc themeCalc,
}) {
  final padding = themeCalc.shaftHeaderPadding;
  final contentSize = Size(
    columnWidth - padding.horizontal,
    themeCalc.shaftHeaderContentHeight,
  );
  return Bx.pad(
    padding: themeCalc.shaftHeaderPadding,
    child: content(nodeBits.sized(contentSize)),
  );
}

@freezedStruct
class MenuItem with _$MenuItem {
  MenuItem._();

  factory MenuItem({
    required String label,
    required ShortcutFr callback,
  }) = _MenuItem;
}


extension ShaftSizedBitsX on SizedNodeBuilderBits {
  Bx shaft(
    ShaftBuilder builder,
  ) {
    return shaftBx(
      sizedBits: this,
      builder: builder,
    );
  }

  Bx menuShaft({
    required String label,
    required List<MenuItem> items,
  }) {
    return shaft(
      (headerBits, contentBits) {
        final pageBx = menuBx(
          sizedBits: contentBits,
          itemCount: items.length,
          itemBuilder: (index, sizedBits) {
            return menuItemBx(
              menuItem: items[index],
              sizedBits: sizedBits,
            );
          },
        );

        if (pageBx.showPaginator) {
          // TODO
        }

        return ShaftParts(
          header: headerBits.left(
            headerBits.centerAlongY(
              textBx(
                text: label,
                style: themeCalc.shaftHeaderTextStyle,
              ),
            ),
          ),
          content: pageBx.bx,
        );
      },
    );
  }

  MenuItem opener({
    required String label,
    required ShaftOpener builder,
  }) {
    return MenuItem(
      label: label,
      callback: fw(() {
        configBits.state.rebuild((message) {
          message.topShaft = MdiShaftMsg$.create(
            parent: shaftMsg,
          ).also(builder);
        });
      }),
    );
  }

  MenuItem openerFr({
    required String label,
    required ShaftOpener builder,
  }) {
    return MenuItem(
      label: label,
      callback: fw(() {
        configBits.state.rebuild((message) {
          message.topShaft = MdiShaftMsg$.create(
            parent: shaftMsg,
          ).also(builder);
        });
      }),
    );
  }

}

typedef ShaftOpener = void Function(MdiShaftMsg shaft);