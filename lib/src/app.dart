import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';

part 'app.freezed.dart';

@freezed
class MdiAppBits with _$MdiAppBits, HasConfigBits {
  MdiAppBits._();

  factory MdiAppBits({
    required Isar isar,
    required MdiConfigBits configBits,
    required Fr<Size> screenSize,
  }) = _MdiAppBits;

  final OpBuilder opBuilder = OpBuilder();
}

mixin HasAppBits {
  MdiAppBits get appBits;

  late final configBits = appBits.configBits;
}
