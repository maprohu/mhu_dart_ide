import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/ui.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';

class HwPaginatorController {
  final firstIndex = fw(0);
}
Widget hwPaginator({
  double separator = 1,
  required double itemHeight,
  required int itemCount,
  required Widget Function(int index) itemBuilder,
  required UiBuilder ui,
  required HwPaginatorController controller,
  HWidget Function(HWidget controls)? header,
}) {
  HWidget defaultHeader(HWidget controls) {
    return hwColumn(
      children: [
        controls.withPadding(),
        hwDivider(separator + 1),
      ],
    );
  }

  header ??= defaultHeader;

  final controls = hwRow(children: []);



  return LayoutBuilder(
    builder: (context, constraints) {
      final height = constraints.maxHeight;


    },
  );
}
