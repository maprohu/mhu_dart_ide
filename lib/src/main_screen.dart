import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/op_shortucts.dart';
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

typedef OpShortcut = String;
typedef OpCallback = VoidCallback?;

typedef OpBuildHandle = OpShortcut Function();

class _BuildReg {
  late final OpShortcut shortcut;
  final OpCallback action;

  _BuildReg(this.action);
}


class OpBuilder {
  final _ops = <_BuildReg>[];

  OpBuildHandle register(OpCallback callback) {
    assert(!_built);
    final reg = _BuildReg(callback);
    _ops.add(reg);
    return () => reg.shortcut;
  }

  var _built = false;
  OpLookup build() {
    assert(!_built);
    _built = true;

    final shortcuts = OpShortcuts.generateShortcuts(_ops.length);
    _ops.zipForEachWith(shortcuts, (reg, shortcut) {
      reg.shortcut = shortcut;
    });

    return OpLookup(this);

  }
}

class OpLookup {
  final OpBuilder _builder;

  OpLookup(this._builder);

  void handleKey(LogicalKeyboardKey key) {}


}
