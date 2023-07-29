import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Op;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/widgets/op_icon.dart';
import 'package:mhu_dart_ide/src/widgets/op_keys.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'op.dart';
import 'widgets/menu.dart';

typedef OpState = Fr<Keys>;

typedef OpOrder = IList<int>;

int compareOpOrder(OpOrder a, OpOrder b) => iterableCompare<num>(b, a);

class OpReg {
  final OpScreen _screen;
  final OpOrder _orderBase;
  final int _index;

  late final _order = _orderBase.add(_index);

  OpState register({
    required Op op,
    required VoidCallback action,
    required DspReg disposers,
  }) {
    return _screen.register(
      op: op,
      order: _order,
      disposers: disposers,
      action: action,
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
  Widget icon(Op op, Watch<VoidCallback?> action) {
    return widget(
      op: op,
      action: action,
      builder: (keys) => OpIcon(op: op, keys: keys),
    );
  }

  Widget keys(Op op, Watch<VoidCallback?> action) {
    return widget(
      op: op,
      action: action,
      builder: (keys) => OpKeys(keys: keys),
    );
  }



  Widget widget({
    required Op op,
    required Watch<VoidCallback?> action,
    required Widget Function(Keys? keys) builder,
  }) {
    return flcFrr(() {
      final callback = action();

      if (callback == null) {
        return builder(null);
      }

      return flcDsp((disposers) {
        final keysFr = register(
          op: op,
          action: callback,
          disposers: disposers,
        );
        return keysFr.asKey(builder);
      }).withKey(callback);
    });
  }

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
  final VoidCallback action;
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

  late final _opChars = _disposers.fr(() {
    final ops = _ops();

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

    final opsSorted = ops.entries
        .sortedByCompare(
          (e) => e.value.highestOrder.read(),
          compareOpOrder,
        )
        .map((e) => e.key);

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

    return opChars.map((op, chars) {
      if (chars.startsWith(pressedChars)) {
        return MapEntry(
          op,
          (
            chars: chars,
            pressedCount: pressedCount,
          ),
        );
      } else {
        return MapEntry(
          op,
          (
            chars: "",
            pressedCount: 0,
          ),
        );
      }
    });
  });

  OpState register({
    required Op op,
    required OpOrder order,
    required DspReg disposers,
    required VoidCallback action,
  }) {
    final handleDisposers = DspImpl();
    _ops.update((ops) {
      var handle = ops[op];

      if (handle == null) {
        handle = _Handle(
          action: action,
        );
        ops = ops.add(op, handle);
      }

      final finalHandle = handle;
      finalHandle.addOrder(order);
      handleDisposers.add(() async {
        await finalHandle.remove(order, () {
          _ops.update((ops) => ops.remove(op));
        });
      });

      return ops;
    });

    final stateDisposers = DspImpl();
    final state = stateDisposers.fr(() => _opStates()[op]!);

    disposers.add(() async {
      final stateFut = stateDisposers.dispose();
      await handleDisposers.dispose();
      await stateFut;
    });

    return state;
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
      case []:
        return;
      case [final single]:
        assert(single.value.chars == newPressed);
        _pressedChars.value = '';
        _ops.read()[single.key]!.action();
      default:
      // no match for key, ignore
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
