import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/screen/screen.dart';

import '../../proto.dart';
import '../shaft.dart';

extension OptionsHasShaftBuilderBitsX on HasShaftBuilderBits {
  VoidCallback optionsOpenerCallback() => openerCallback(
        (shaft) => shaft.ensureOptions(),
      );
}
