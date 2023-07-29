import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'dart:ui' as ui;

// part 'op.freezed.dart';

typedef Op = Object;
// @Freezed(
//   equal: false,
//   when: FreezedWhenOptions.none,
// )
// class Op with _$Op {
//   static const iconSize = 18.0;
//
//   const factory Op({
//     Widget? icon,
//     String? label,
//   }) = _Op;
//
//   factory Op.icon({
//     required IconData icon,
//     String? label,
//   }) =>
//       Op(
//         label: label,
//         icon: Icon(
//           icon,
//           size: iconSize,
//         ),
//       );
//
//   factory Op.svg({
//     required String asset,
//     String? label,
//   }) {
//     return Op(
//       label: label,
//       icon: Builder(
//         builder: (context) {
//           final theme = IconTheme.of(context);
//           return SvgPicture.asset(
//             "assets/icons/$asset.svg",
//             width: iconSize,
//             height: iconSize,
//             colorFilter: ui.ColorFilter.mode(
//               theme.color ?? Colors.white,
//               BlendMode.srcIn,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

typedef Keys = ({
  String chars,
  int pressedCount,
});

class Ops {
  const Ops._();

  static const instance = Ops._();
}

const ops = Ops.instance;
