import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/op.dart';

class OpShortcuts {
  // unused
  // used qwertyuiop
  // used asdfghjkl;
  // used \zxcvbnm,./
  static const lowercaseKeyOrder = r"fjdksla;ghvnmruc,eix.woz/tybqp['";
  static final keyChars = lowercaseKeyOrder.characters;
  static const keyCount = lowercaseKeyOrder.length;
  static final uppercaseKeyLabelSet =
      keyChars.map((e) => e.toUpperCase()).toISet();
  static final lowercaseKeyLabelSet =
      keyChars.map((e) => e.toLowerCase()).toISet();

  static final uppercaseCharToLogicalKey = {
    for (final lk in LogicalKeyboardKey.knownLogicalKeys)
      if (uppercaseKeyLabelSet.contains(lk.keyLabel)) lk.keyLabel: lk
  }.toIMap();

  static final logicalKeyOrder = lowercaseKeyOrder.characters
      .map((e) => uppercaseCharToLogicalKey[e.toUpperCase()]!)
      .toIList();

  static final shortcutKeyOrder =
      logicalKeyOrder.map((e) => ShortcutKey.of(e)).toIList();
  static final IList<OpShortcut> singleShortcutKeyOrder =
      shortcutKeyOrder.map((sk) => IList<ShortcutKey>([sk])).toIList();


  static final allShortcutKeys = shortcutKeyOrder;

  static Iterable<OpShortcut> generateShortcuts(int count) {
    final singleKeyOpShortcuts = singleShortcutKeyOrder;

    final opShortcutsQueue = DoubleLinkedQueue.of(singleKeyOpShortcuts);
    var availableShortcutsCount = opShortcutsQueue.length;

    while (availableShortcutsCount < count) {
      final prefixShortcut = opShortcutsQueue.removeFirst();

      final lastKeyOfPrefixShortcut = prefixShortcut.last;

      final suffixSingleKeysWithDoubleFirst =
          [lastKeyOfPrefixShortcut].followedBy(
        shortcutKeyOrder.where((c) => c != lastKeyOfPrefixShortcut),
      );

      final newShortcuts = suffixSingleKeysWithDoubleFirst.map(
        (suffix) => prefixShortcut.add(suffix),
      );

      opShortcutsQueue.addAll(newShortcuts);

      availableShortcutsCount += keyCount - 1;
    }

    return opShortcutsQueue;
  }
}

class ShortcutKey {
  final LogicalKeyboardKey keyboardKey;

  final String display;

  ShortcutKey._(this.keyboardKey)
      : display = keyboardKey.keyLabel.toLowerCase();

  static final of = Cache(ShortcutKey._);

  @override
  String toString() {
    return 'ShortcutKey{$display}';
  }
}
