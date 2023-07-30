import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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

  static Iterable<String> generateShortcuts(int count) {
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

    return keysQueue;
  }
}
