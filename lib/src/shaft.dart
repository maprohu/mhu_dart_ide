import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/build_runner.dart';
import 'package:mhu_dart_ide/src/shaft/config.dart';
import 'package:mhu_dart_ide/src/shaft/error.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_ide/src/theme.dart';
import 'package:mhu_dart_ide/src/widgets/menu.dart';
import 'package:mhu_dart_ide/src/widgets/shortcut.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../proto.dart';
import 'flex.dart';
import 'screen.dart';
import 'shaft/main_menu.dart';
import 'widgets/boxed.dart';

part 'shaft.freezed.dart';

FlexNode<Bx> mdiShaftFlexNode({
  required NodeBuilderBits nodeBits,
  required double height,
  required ShaftCalcChain calcChain,
}) {
  final shaftMsg = calcChain.shaftMsg;
  return FlexNode(
    grow: false,
    builder: (width) {
      return nodeBits.sizedBxFrom(
        width: width,
        height: height,
        builder: (sizedBits) {
          return switch (shaftMsg.type) {
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
            _ => errorShaftBx(
                sizedBits: sizedBits,
                message: "no shaft: ${shaftMsg.whichType().name}",
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
    :size,
    :width,
    :height,
    :themeCalc,
  ) = sizedBits;

  final ThemeCalc(
    :shaftHeaderDividerThickness,
    :shaftHeaderWithDividerHeight,
    :shaftHeaderPadding,
    :shaftHeaderContentHeight,
    :shaftHeaderOuterHeight,
  ) = themeCalc;

  final headerContentWidth = width - shaftHeaderPadding.horizontal;
  final contentHeight = height - shaftHeaderWithDividerHeight;

  final parts = builder(
    sizedBits.withSize(Size(headerContentWidth, shaftHeaderContentHeight)),
    sizedBits.withSize(Size(width, contentHeight)),
  );

  return Bx.col(
    size: size,
    rows: [
      Bx.pad(
        padding: shaftHeaderPadding,
        child: parts.header,
        size: size.withHeight(shaftHeaderOuterHeight),
      ),
      Bx.horizontalDivider(
        thickness: shaftHeaderDividerThickness,
        width: width,
      ),
      parts.content,
    ],
  );
}

@freezedStruct
class MenuItem with _$MenuItem {
  MenuItem._();

  factory MenuItem({
    required String label,
    required ShortcutCallback callback,
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

        return ShaftParts(
          header: headerBits.left(
            headerBits.centerHeight(
              textBx(
                text: label,
                style: themeCalc.shaftHeaderTextStyle,
              ),
            ),
          ),
          content: pageBx,
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
      callback: (() {
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
      callback: (() {
        configBits.state.rebuild((message) {
          message.topShaft = MdiShaftMsg$.create(
            parent: shaftMsg,
          ).also(builder);
        });
      }),
    );
  }

  Bx header({required String label, VoidCallback? callback}) {
    if (callback == null) {
      return headerText.centerLeft(label);
    }

    return fillLeft(
      left: (sizedBits) => sizedBits.headerText.centerLeft(label),
      right: centerHeight(
        nodeBits.shortcut(callback),
      ),
    );
  }

  Bx fillLeft({
    required NodeBuilder left,
    required Bx right,
  }) {
    return Bx.row(
      columns: [
        left(
          withWidth(width - right.width),
        ),
        right,
      ],
      size: size,
    );
  }

  Bx fillRight({
    required Bx left,
    required NodeBuilder right,
  }) {
    return Bx.row(
      columns: [
        left,
        right(
          withWidth(width - left.width),
        ),
      ],
      size: size,
    );
  }

  Bx fillBottom({
    required Bx top,
    required NodeBuilder bottom,
  }) {
    return Bx.col(
      rows: [
        top,
        bottom(withHeight(height - top.height)),
      ],
      size: size,
    );
  }
  Bx fillTop({
    required NodeBuilder top,
    required Bx bottom,
  }) {
    return Bx.col(
      rows: [
        top(withHeight(height - bottom.height)),
        bottom,
      ],
      size: size,
    );
  }
}

typedef ShaftOpener = void Function(MdiShaftMsg shaft);
