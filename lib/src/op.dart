// ignore_for_file: unused_import

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/op_shortucts.dart';

typedef OpShortcut = IList<ShortcutKey>;
typedef OpCallback = VoidCallback? Function();

typedef OpState = int?;

typedef OpBuildHandle = ({
  OpShortcut Function() shortcut,
  OpState Function() watchState,
});

class _BuildReg {
  late final OpShortcut shortcut;
  final OpCallback action;

  _BuildReg(this.action);
}

class OpBuilder {
  OpBuilder._();

  final _ops = <_BuildReg>[];

  final _pressed = fw(OpShortcut());

  OpBuildHandle register(OpCallback callback) {
    assert(!_built);
    final reg = _BuildReg(callback);
    _ops.add(reg);

    return (
      shortcut: () => reg.shortcut,
      watchState: () {
        final pressed = _pressed();
        if (pressed.isEmpty) {
          return 0;
        }
        final pressedCount = pressed.length;
        final shortcut = reg.shortcut;
        if (shortcut.length < pressedCount) {
          return null;
        }
        if (shortcut.take(pressedCount) == pressed) {
          return pressedCount;
        }
        return null;
      },
    );
  }

  var _built = false;

  OpLookup _build() {
    assert(!_built);
    _built = true;

    final shortcuts = OpShortcuts.generateShortcuts(_ops.length);
    _ops.zipForEachWith(shortcuts, (reg, shortcut) {
      reg.shortcut = shortcut;
    });

    return OpLookup(this);
  }

  static T build<T>(T Function(OpBuilder opBuilder) builder) {
    final opBuilder = OpBuilder._();
    try {
      return builder(opBuilder);
    } finally {
      opBuilder._build();
    }
  }
}

class OpLookup {
  final OpBuilder _builder;

  OpLookup(this._builder);

  void handleKey(LogicalKeyboardKey key) {}
}
