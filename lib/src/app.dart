import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';

part 'app.g.has.dart';

part 'app.g.compose.dart';

@Has()
typedef IsarDatabase = Isar;

@Has()
typedef ScreenSizeFr = Fr<Size>;

@Compose()
abstract class AppBits implements ConfigBits, HasScreenSizeFr, HasOpBuilder {}

// mixin HasAppBits {
//   MdiAppBits get appBits;
//
//   late final configBits = appBits.configBits;
// }
