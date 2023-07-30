import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op_registry.dart';
import 'package:mhu_dart_ide/src/settings.dart';
import 'package:mhu_dart_ide/src/ui.dart';
import 'package:mhu_dart_ide/src/widgets/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'main_menu.dart';
import 'widgets/columns.dart';

part 'app.freezed.dart';

@freezed
class MdiAppBits with _$MdiAppBits {
  MdiAppBits._();

  final _disposers = DspImpl();

  factory MdiAppBits({
    required Isar isar,
    required MdiConfigBits configBits,
  }) = _MdiAppBits;

  late final widgetParent = ColumnWidgetParent(
    columnBits: ColumnBits(
      parent: null,
      appBits: this,
      opReg: opScreen.root.push(),
    ),
  );
  late final columnBits = _disposers.fw<ColumnWidgetBits?>(
    mdiMainMenu(
      parent: widgetParent,
    ),
  );

  late final openColumnsSet = _disposers.fr(
    () => columnBits().childToParentIterable.toISet(),
  );

  late final opScreen = OpScreen(_disposers);

  late final columnCount = _disposers.fw(4);

  late final robotoSlabTextStyle = GoogleFonts.robotoSlab().copyWith(
    fontSize: 14,
    color: Colors.white,
  );
  late final monoTextStyle = GoogleFonts.robotoMono().copyWith(
    fontSize: 14,
    color: Colors.white,
  );

  late final builtinTextStyle = const TextStyle(
    fontSize: 14,
  );

  // late final textStyle = builtinTextStyle;
  late final textStyle = robotoSlabTextStyle;

  late final ui = UiBuilder(
    opReg: opScreen.root,
    itemText: TextBuilder(
      textStyle: textStyle,
    ),
    headerText: TextBuilder(
      textStyle: textStyle.apply(
        fontSizeFactor: 1.05,
      ),
    ),
    keysText: TextBuilder(
      textStyle: textStyle.apply(
        color: Colors.yellow,
      ),
    ),
    keysPressedText: TextBuilder(
      textStyle: textStyle.apply(
        color: Colors.red,
      ),
    ),
  );
}

mixin HasAppBits {
  MdiAppBits get appBits;

  late final ui = appBits.ui;

  late final configBits = appBits.configBits;

  late final opScreen = appBits.opScreen;
}
