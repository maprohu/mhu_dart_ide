import 'package:flutter/material.dart';

class Paddings {
  static EdgeInsets topLeft({
    required Size outer,
    required Size inner,
  }) {
    return EdgeInsets.only(
      right: outer.width - inner.width,
      bottom: outer.height - inner.height,
    );
  }

  static EdgeInsets centerLeft({
    required Size outer,
    required Size inner,
  }) {
    final vertical = (outer.height - inner.height) / 2;
    return EdgeInsets.only(
      right: outer.width - inner.width,
      top: vertical,
      bottom: vertical,
    );
  }

  static EdgeInsets top({
    required double outer,
    required double inner,
  }) {
    return EdgeInsets.only(
      bottom: outer - inner,
    );
  }

  static EdgeInsets centerY({
    required double outer,
    required double inner,
  }) {
    return EdgeInsets.symmetric(
      vertical: (outer - inner) / 2,
    );
  }

  static EdgeInsets centerX({
    required double outer,
    required double inner,
  }) {
    return EdgeInsets.symmetric(
      horizontal: (outer - inner) / 2,
    );
  }
}
