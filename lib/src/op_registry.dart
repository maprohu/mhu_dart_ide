import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Op;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';

import 'op.dart';

part 'op_registry.freezed.dart';

typedef OpState = Watch<Keys?>;

typedef OpOrder = IList<int>;

int compareOpOrder(OpOrder a, OpOrder b) => iterableCompare<num>(b, a);

typedef WatchAct = Watch<Act?>;

@freezed
sealed class Act with _$Act {
  factory Act.busy() = ActBusy;

  factory Act.act(VoidCallback action) = ActAct;
}

class OpReg {
  final OpScreen _screen;
  final OpOrder _orderBase;
  final int _index;

  late final _order = _orderBase.add(_index);

  OpState register({
    required WatchAct action,
    required DspReg disposers,
    Op? op,
  }) {
    return _screen.register(
      order: _order,
      disposers: disposers,
      action: action,
      op: op,
    );
  }

  OpReg._({
    required OpScreen screen,
    required OpOrder orderBase,
    required int index,
  })  : _screen = screen,
        _orderBase = orderBase,
        _index = index;
}

extension OpRegX on OpReg {
  OpReg push() => OpReg._(
        screen: _screen,
        orderBase: _orderBase,
        index: _index + 1,
      );

  OpReg fork() => OpReg._(
        screen: _screen,
        orderBase: _order,
        index: 0,
      );
}

class _Handle {
  final WatchAct action;
  final disposers = DspImpl();
  final orders = HeapPriorityQueue<OpOrder>(compareOpOrder);

  late final highestOrder = disposers.fw(OpOrder());

  void addOrder(OpOrder order) {
    orders.add(order);
    highestOrder.value = orders.first;
  }

  Future<void> remove(OpOrder order, void Function() dispose) async {
    final removed = orders.remove(order);
    assert(removed);
    if (orders.isEmpty) {
      dispose();
      await disposers.dispose();
    }
  }

  _Handle({
    required this.action,
  });
}

class OpScreen {
  final DspReg _disposers;

  static final _emptyOps = IMap<Op, _Handle>();

  late final _ops = _disposers.fw(_emptyOps);

  late final _pressedChars = _disposers.fw("");

  OpScreen(this._disposers);

  // unused
  // used qwertyuiop
  // used asdfghjkl;
  // used \zxcvbnm,./
  static const keyOrder = r"fjdksla;ghvnmruc,eix.woz/tybqp['\";
  static final keyChars = keyOrder.characters;
  static const keyCount = keyOrder.length;
  static final keyLabelSet =
      OpScreen.keyChars.map((e) => e.toUpperCase()).toISet();

  late final pressedCount = _disposers.fr(() => _pressedChars().length);
  late final _opsUnlessAsyncBusy = _disposers.fr(() {
    return _taskQueue.busy() ? _emptyOps : _ops();
  });

  late final _activeOps = _disposers.fr(() {
    final opHandles = _opsUnlessAsyncBusy();

    final Iterable<({Act action, Op op, IList<int> order})> records =
        opHandles.mapTo((op, handle) {
      final action = handle.action();
      if (action == null) {
        return null;
      }

      return (
        op: op,
        action: action,
        order: handle.highestOrder.read(),
      );
    }).whereNotNull();

    return IMap.fromValues(
      values: records,
      keyMapper: (r) => r.op,
    );
  });

  late final _opChars = _disposers.fr(() {
    final ops = _activeOps();

    final count = ops.length;
    final keysQueue = DoubleLinkedQueue<String>.from(keyChars);
    var availableKeysCount = keysQueue.length;

    while (availableKeysCount < count) {
      final first = keysQueue.removeFirst();

      final firstLast = first.characters.last;

      keysQueue.addAll(
        [firstLast]
            .followedBy(
              keyChars.where((c) => c != firstLast),
            )
            .map((c) => "$first$c"),
      );

      availableKeysCount += keyCount - 1;
    }

    final opsSorted = ops.values
        .sortedByCompare(
          (e) => e.order,
          compareOpOrder,
        )
        .map(
          (e) => (
            action: e.action,
            op: e.op,
          ),
        );

    return IMap.fromIterable(
      opsSorted.zipWith(
        keysQueue,
      ),
      keyMapper: (r) => r.$1.op,
      valueMapper: (r) => (
        action: r.$1.action,
        chars: r.$2,
      ),
    );
  });

  late final _opActs = _disposers.fr(() {
    final opChars = _opChars();
    final pressedChars = _pressedChars();

    final entries = opChars.entries.map(
      (e) {
        switch (e.value.action) {
          case ActBusy():
            return null;
          case ActAct(:final action):
            final chars = e.value.chars;
            if (!chars.startsWith(pressedChars)) {
              return null;
            }
            return (
              op: e.key,
              chars: chars,
              action: action,
            );
        }
      },
    ).whereNotNull();

    return IMap.fromIterable(
      entries,
      keyMapper: (e) => e.op,
      valueMapper: (e) => (
        chars: e.chars,
        action: e.action,
      ),
    );
  });
  late final _opStates = _disposers.fr(() {
    return _opActs().map(
      (key, value) => MapEntry(
        key,
        (chars: value.chars),
      ),
    );
  });

  OpState register({
    required OpOrder order,
    required DspReg disposers,
    required WatchAct action,
    Op? op,
  }) {
    final finalOp = op ?? Op();

    _ops.update((ops) {
      var handle = ops[finalOp];

      if (handle == null) {
        handle = _Handle(
          action: action,
        );
        ops = ops.add(finalOp, handle);
      }

      final finalHandle = handle;
      finalHandle.addOrder(order);
      disposers.add(() async {
        await finalHandle.remove(order, () {
          _ops.update((ops) => ops.remove(finalOp));
        });
      });

      return ops;
    });

    return () => _opStates()[finalOp];
  }

  late final root = OpReg._(
    screen: this,
    orderBase: OpOrder(),
    index: 0,
  );

  void charPressed(String char) {
    final alreadyTyped = _pressedChars.read();
    final newPressed = "$alreadyTyped$char";

    final candidates = _opActs
        .read()
        .entries
        .where(
          (e) => e.value.chars.startsWith(newPressed),
        )
        .take(2) // we only need to now if there are 0, 1 or more matches
        .toList();

    switch (candidates) {
      case []: // no matching op, ignore key
        return;
      case [final single]: // found a single match, execute
        assert(single.value.chars == newPressed);
        _pressedChars.value = '';
        single.value.action();
      default: // multiple matches, wait for more chars
        _pressedChars.value = newPressed;
    }
  }

  Iterable<({LogicalKeyboardKey key, VoidCallback handler})>
      keyHandlers() sync* {
    for (final key in LogicalKeyboardKey.knownLogicalKeys) {
      final keyLabel = key.keyLabel;
      if (keyLabelSet.contains(keyLabel)) {
        final char = keyLabel.toLowerCase();
        yield (key: key, handler: () => charPressed(char));
      }
    }
  }

  late final _taskQueue = TaskQueue(disposers: _disposers);

  void screenTask(Future<void> Function() task) {
    _taskQueue.submit(task);
  }
}

typedef OpHandle = ({
  OpState state,
  HasSizedWidget widget,
});

mixin HasOpScreen {
  OpScreen get opScreen;

  void screenTask(Future<void> Function() task) {
    opScreen.screenTask(task);
  }
}
