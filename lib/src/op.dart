// ignore_for_file: unused_import

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/proto.dart';
import 'package:mhu_dart_ide/src/bx/screen.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/keyboard.dart';
import 'package:mhu_dart_ide/src/model.dart';

part 'op.freezed.dart';

part 'op.g.has.dart';
// part 'op.g.compose.dart';

typedef OpCallback = VoidCallback;

typedef OpState = int?;

final emptyShortcut = OpShortcut();

@freezedStruct
class OpBuildHandle with _$OpBuildHandle {
  OpBuildHandle._();

  factory OpBuildHandle({
    required OpShortcut Function() shortcut,
    required OpState Function() watchState,
  }) = _OpBuildHandle;

  static final empty = OpBuildHandle(
    shortcut: () => emptyShortcut,
    watchState: () => 0,
  );
}

class _BuildReg {
  late final OpShortcut shortcut;
  final OpCallback action;

  final pressed = fw<int?>(0);

  _BuildReg(this.action);
}

class _OpBuild {
  final OpBuilder builder;
  final ops = <_BuildReg>[];
  final keyListeners = <ShortcutKeyListener>{};
  final rawKeyListeners = <RawKeyListener>{};

  final bool isFocused;

  final _callbackSet = <OpCallback>{};

  _OpBuild(
    this.builder, {
    required this.isFocused,
  });

  OpBuildHandle register(OpCallback callback) {
    if (isFocused) {
      return OpBuildHandle.empty;
    }

    assert(
      _callbackSet.add(callback),
      "callback already added: $callback",
    );

    final reg = _BuildReg(callback);

    ops.add(reg);

    return OpBuildHandle(
      shortcut: () => reg.shortcut,
      watchState: () {
        return reg.pressed();
      },
    );
  }

  late final node = _OpNode(
    regs: ops,
    level: 0,
    build: this,
  );

  late _OpNode currentNode = node;

  void invokeKeyListeners(ShortcutKey key) {
    for (final listener in keyListeners) {
      listener(key);
    }
  }

  void invokeRawKeyListeners(KeyEvent keyEvent) {
    for (final listener in rawKeyListeners) {
      listener(keyEvent);
    }
  }

  void keyPressed(ShortcutKey key) {
    currentNode.keyPressed(key);
  }

  void onKeyEvent(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent) {
      ShortcutKey shortcutKey;
      final character = keyEvent.character;
      if (character != null) {
        shortcutKey = CharacterShortcutKey(character);
      } else {
        shortcutKey = LogicalShortcutKey(keyEvent.logicalKey);
      }

      if (isFocused) {
        invokeKeyListeners(shortcutKey);
      } else {
        keyPressed(shortcutKey);
      }
    }
    invokeRawKeyListeners(keyEvent);
  }
}

class _OpNode {
  final Iterable<_BuildReg> regs;
  final int level;
  final _OpBuild build;

  _OpNode({
    required this.regs,
    required this.level,
    required this.build,
  });

  late final map = regs
      .where((r) => r.shortcut.length > level)
      .groupListsBy((r) => r.shortcut[level])
      .map(
        (key, value) => MapEntry(
          key,
          _OpNode(
            regs: value,
            level: level + 1,
            build: build,
          ),
        ),
      );

  void keyPressed(ShortcutKey key) {
    if (level != 0 && key == ShortcutKey.escape) {
      build.builder._clearPressed();
      return;
    }
    final node = map[key];

    if (node == null) {
      build.invokeKeyListeners(key);
    } else {
      node.click(this, key);
    }
  }

  late final isLeaf = regs.length == 1;

  void click(_OpNode parent, ShortcutKey key) {
    if (!isLeaf) {
      for (final reg in regs) {
        reg.pressed.value = level;
      }
      for (final entry in parent.map.entries) {
        if (entry.key != key) {
          for (final reg in entry.value.regs) {
            reg.pressed.value = null;
          }
        }
      }
      build.currentNode = this;
    } else {
      final action = regs.single.action;
      build.builder._clearPressed();
      action();
    }
  }
}

typedef ShortcutKeyListener = void Function(ShortcutKey key);
typedef RawKeyListener = void Function(KeyEvent keyEvent);

@Has()
class OpBuilder {
  final ConfigBits configBits;
  late _OpBuild _opBuild;

  // final _pressed = fw(emptyShortcut);

  // final allShortcutKeys = OpShortcuts.allShortcutKeys;

  final _exclude = <OpShortcut>{};

  late final shortcutKeysInOrder = OpShortcuts.shortcutKeyOrder;

  late final _shortcutChain = ShortcutSet.first(
    shortcutKeysInOrder,
  );

  OpBuilder(this.configBits);

  void _clearPressed() {
    // _node = _opBuild.node;
    for (final reg in _opBuild.ops) {
      reg.pressed.value = 0;
    }
  }

  void addKeyListener(ShortcutKeyListener listener) {
    assert(!_built);
    _opBuild.keyListeners.add(listener);
  }

  void _clearFocusOnEscape(ShortcutKey shortcutKey) {
    if (shortcutKey == ShortcutKey.escape) {
      configBits.clearFocusedShaft();
      // configBits.stateFw.rebuild((message) {
      //   message.clearFocusedShaft();
      // });
    }
  }

  // void registerClearFocusOnEscape() {
  //   addKeyListener(_clearFocusOnEscape);
  // }

  void keyPressed(ShortcutKey key) {
    _opBuild.keyPressed(key);

    // if (key == ShortcutKey.escape) {
    //   _clearPressed();
    //   return;
    // }

    // _node.keyPressed(key);
  }

  static const shortuctEq = IterableEquality<ShortcutKey>();

  OpBuildHandle register(OpCallback callback) {
    assert(!_built);

    return _opBuild.register(callback);
  }

  var _built = true;

  Iterable<OpShortcut> _findShortcuts(int count) {
    final exclude = _exclude;
    if (exclude.isEmpty) {
      return _shortcutChain.iterable
          .firstWhere((s) => s.count >= count)
          .shortcutList;
    } else {
      final target = <OpShortcut>[];
      for (final set in _shortcutChain.iterable) {
        final found = set.collectExcluding(
          count: count,
          exclude: exclude,
          target: target,
        );
        if (found) {
          return target;
        }
        target.clear();
      }
      throw "never";
    }
  }

  void _build() {
    assert(!_built);
    _built = true;

    final shortcuts = _findShortcuts(_opBuild.ops.length);
    _opBuild.ops.zipForEachWith(shortcuts, (reg, shortcut) {
      reg.shortcut = shortcut;
    });
  }

  T build<T>(
    T Function() builder,
  ) {
    assert(_built);
    _built = false;

    final state = configBits.stateCalcFr().state;
    final focusedIndex = state.focusedShaft.indexFromLeftOpt;

    final isFocused = focusedIndex != null &&
        state.effectiveTopShaft.shaftByIndexFromLeft(focusedIndex) != null;

    _opBuild = _OpBuild(
      this,
      isFocused: isFocused,
    );

    try {
      return builder();
    } finally {
      _build();
    }
  }

  void onKeyEvent(KeyEvent keyEvent) {
    _opBuild.onKeyEvent(keyEvent);
  }
}

// class OpBuilderShortcutActivator extends ShortcutActivator {
//   final OpBuilder opBuilder;
//
//   OpBuilderShortcutActivator(this.opBuilder);
//
//   @override
//   bool accepts(RawKeyEvent event, RawKeyboard state) {
//     return opBuilder._opBuild.isFocused;
//   }
//
//   @override
//   String debugDescribeKeys() {
//     return runtimeType.toString();
//   }
//
//   @override
//   Iterable<LogicalKeyboardKey>? get triggers => null;
// }
