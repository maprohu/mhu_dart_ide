import 'package:flutter/material.dart';

import '../op.dart';

class OpKeys extends StatelessWidget {
  final Keys? keys;

  const OpKeys({super.key, required this.keys});

  static const color = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: keys != null,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 16,
        ),
        child: Text(
          keys?.chars ?? "",
          style: const TextStyle(
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
