import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

class MdiIcons {
  static const iconSize = 16.0;

  static Widget _svg(String asset) {
    return SvgPicture.asset(
      "assets/icons/$asset.svg",
      width: iconSize,
      height: iconSize,
      colorFilter: const ui.ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
    );
  }

  static Widget _icon(IconData icon) {
    return Icon(
      icon,
      size: iconSize,
    );
  }

  static final addColumn = _svg("ftinscol");
  static final removeColumn = _svg("ftremcol");
  static final help = _icon(Icons.help_outline);
  static final pages = _icon(Icons.import_contacts_outlined);
}
