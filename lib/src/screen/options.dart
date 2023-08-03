import 'package:flutter/material.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';


extension OptionsHasShaftBuilderBitsX on HasShaftBuilderBits {
  VoidCallback optionsOpenerCallback() => openerCallback(
        (shaft) => shaft.ensureOptions(),
      );
}
