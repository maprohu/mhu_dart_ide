import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import 'package:mhu_dart_ide/src/widgets/sized.dart';

class MdiIcons {
  static const _size = 16.0;

  static SizedWidget _svg(String asset) {
    return SvgPicture.asset(
      "assets/icons/$asset.svg",
      width: _size,
      height: _size,
      colorFilter: const ui.ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
    ).withSize(
      width: _size,
      height: _size,
    );
  }

  static SizedWidget _icon(IconData icon) {
    return Icon(
      icon,
      size: _size,
    ).withSize(
      width: _size,
      height: _size,
    );
  }

  static final addColumn = _svg("ftinscol");
  static final removeColumn = _svg("ftremcol");
  static final help = _icon(Icons.help_outline);
}
