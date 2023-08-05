import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';

typedef Options = List<MenuItem>;

extension OptionsHasShaftBuilderBitsX on ShaftBuilderBits {
  VoidCallback optionsOpenerCallback() => openerCallback(
        (shaft) => shaft.ensureOptions(),
      );
}
