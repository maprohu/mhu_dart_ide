import 'package:flutter/material.dart';

import '../op.dart';
import 'op_keys.dart';

class OpIcon extends StatelessWidget {
  final Op op;
  final Keys? keys;

  const OpIcon({
    super.key,
    required this.op,
    required this.keys,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          op.icon ?? (throw "no icon: ${op.label}"),
          const SizedBox(
            height: 1,
          ),
          OpKeys(
            keys: keys,
          ),
        ],
      ),
    );
  }
}
