import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

class MdiMainScreen extends StatelessWidget {
  final ValueListenable<Widget> listenable;

  const MdiMainScreen({super.key, required this.listenable});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: listenable,
        builder: (context, value, child) {
          return StretchWidget(
            child: value,
          );
        },
      ),
    );
  }
}

