import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'dart:ui' as ui;

import 'package:mhu_dart_ide/src/widgets/columns.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

// part 'op.freezed.dart';

typedef OpId = Object;

typedef Keys = ({
  String chars,
});

class Ops {
  const Ops._();

  static const instance = Ops._();
}

const ops = Ops.instance;

typedef Registrar<T> = T Function(DspReg disposers);
typedef WidgetLinker<T> = Registrar<T> Function();

Widget linkWidget<T>({
  required WidgetLinker<T> linker,
  required Widget Function(T bits) builder,
}) {
  return flcFrr(() {
    final registrar = linker();

    return flcDsp((disposers) {
      final bits = registrar(disposers);

      return flcFrr(() {
        return builder(bits);
      });
    });
  });
}
