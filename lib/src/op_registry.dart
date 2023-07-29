import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Op;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';

import 'op.dart';

typedef OpState = Watch<Keys?>;

typedef OpOrder = IList<int>;

int compareOpOrder(OpOrder a, OpOrder b) => iterableCompare<num>(b, a);

class OpReg {
  final OpScreen _screen;
  final OpOrder _orderBase;
  final int _index;

  late final _order = _orderBase.add(_index);

  OpState register({
    required Watch<VoidCallback?> action,
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
  // Widget icon(Op op, Watch<VoidCallback?> action) {
  //   return widget(
  //     op: op,
  //     action: action,
  //     builder: (keys) => OpIcon(op: op, keys: keys),
  //   );
  // }

  // Widget keys(Op op, Watch<VoidCallback?> action) {
  //   return widget(
  //     op: op,
  //     action: action,
  //     builder: (keys) => OpKeys(keys: keys),
  //   );
  // }

  // Widget widget({
  //   required Op op,
  //   required Watch<VoidCallback?> action,
  //   required Widget Function(Keys? keys) builder,
  // }) {
  //   return flcFrr(() {
  //     final callback = action();
  //
  //     if (callback == null) {
  //       return builder(null);
  //     }
  //
  //     return flcDsp((disposers) {
  //       final keysFr = register(
  //         op: op,
  //         action: callback,
  //         disposers: disposers,
  //       );
  //       return keysFr.asKey(builder);
  //     }).withKey(callback);
  //   });
  // }

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
  final Watch<VoidCallback?> action;
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
  late final _ops = _disposers.fw(IMap<Op, _Handle>());

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

  late final _activeOps = _disposers.fr(() {
    final opHandles = _ops();

    final records = opHandles.mapTo((op, handle) {
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
    var availableKeysCount = count;
    final keysQueue = DoubleLinkedQueue<String>.from(keyChars);

    while (availableKeysCount < count) {
      final first = keysQueue.removeFirst();

      final firstLast = first.characters.last;

      keysQueue.addAll(
        firstLast.toSingleElementIterable
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
        .map((e) => e.op);

    return IMap<Op, String>.fromEntries(
      opsSorted.zipMapWith(
        keysQueue,
        mapper: MapEntry.new,
      ),
    );
  });

  late final _opStates = _disposers.fr(() {
    final opChars = _opChars();
    final pressedChars = _pressedChars();
    final pressedCount = pressedChars.length;

    final entries = opChars.entries.where(
      (e) => e.value.startsWith(pressedChars),
    );

    return IMap.fromIterable(
      entries,
      keyMapper: (e) => e.key,
      valueMapper: (e) => (
        chars: e.value,
        pressedCount: pressedCount,
      ),
    );
  });

  OpState register({
    required OpOrder order,
    required DspReg disposers,
    required Watch<VoidCallback?> action,
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

    final candidates = _opStates
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
        _activeOps.read()[single.key]!.action();
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
}

typedef OpHandle = ({
  OpState state,
  HasSizedWidget widget,
});
