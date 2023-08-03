// ignore_for_file: unused_import

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/keyboard.dart';

typedef OpShortcut = IList<ShortcutKey>;
typedef OpCallback = VoidCallback;

typedef OpState = int?;

final emptyShortcut = OpShortcut();

typedef OpBuildHandle = ({
  OpShortcut Function() shortcut,
  OpState Function() watchState,
});

class _BuildReg {
  late final OpShortcut shortcut;
  final OpCallback action;

  final pressed = fw<int?>(0);

  _BuildReg(this.action);
}

class _OpBuild {
  final OpBuilder builder;
  final ops = <_BuildReg>[];

  _OpBuild(this.builder);

  late final node = _OpNode(
    regs: ops,
    level: 0,
    build: this,
  );
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
    map[key]?.click(this, key);
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
      build.builder._node = this;
    } else {
      final action = regs.single.action;
      build.builder._clearPressed();
      action();
    }
  }
}

class OpBuilder {
  late _OpBuild _opBuild;
  late _OpNode _node;

  // final _pressed = fw(emptyShortcut);

  final allShortcutKeys = OpShortcuts.allShortcutKeys;

  final _exclude = <OpShortcut>{};

  late final shortcutKeysInOrder = OpShortcuts.shortcutKeyOrder;

  late final _shortcutChain = ShortcutSet.first(
    shortcutKeysInOrder,
  );

  void _clearPressed() {
    _node = _opBuild.node;
    for (final reg in _opBuild.ops) {
      reg.pressed.value = 0;
    }
  }


  void keyPressed(ShortcutKey key) {
    if (key == ShortcutKey.escape) {
      _clearPressed();
      return;
    }

    _node.keyPressed(key);
  }

  static const shortuctEq = IterableEquality<ShortcutKey>();

  OpBuildHandle register(OpCallback callback) {
    assert(!_built);
    final reg = _BuildReg(callback);

    _opBuild.ops.add(reg);

    return (
      shortcut: () => reg.shortcut,
      watchState: () {
        return reg.pressed();
      },
    );
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
    _node = _opBuild.node;
  }

  T build<T>(
    T Function() builder,
  ) {
    assert(_built);
    _built = false;
    _opBuild = _OpBuild(this);

    try {
      return builder();
    } finally {
      _build();
    }
  }
}
