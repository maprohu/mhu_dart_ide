import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/screen/inner_state.dart';

import '../proto.dart';

part 'app.g.has.dart';

part 'app.g.compose.dart';

@Has()
typedef IsarDatabase = Isar;

@Has()
typedef ScreenSizeFr = Fr<Size>;

// @Has()
// typedef AccessInnerState = Future<T> Function<T>(
//   InnerStateKey key,
//   FutureOr<T> Function(InnerStateFw innerStateFw) action,
// );

@Has()
typedef ShaftDataStore = Map<ShaftIndexFromLeft, dynamic>;

@Compose()
abstract class AppBits
    implements ConfigBits, HasScreenSizeFr, HasOpBuilder, HasShaftDataStore {}
