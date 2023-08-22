import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/shaft/error.dart';
import 'package:mhu_dart_ide/src/shaft/main_menu.dart';
import 'package:mhu_dart_ide/src/shaft/options.dart';

import 'shaft_factory.dart' as $lib;

part 'shaft_factory.g.dart';

part 'shaft_factory.g.has.dart';

part 'shaft_factory.g.compose.dart';

typedef ShaftFactoryKey = int;

@Compose()
abstract class ShaftFactory implements HasSingletonKeyHolder<ShaftFactoryKey> {
  factory ShaftFactory() {
    return ComposedShaftFactory(
      singletonKeyHolder: SingletonKeyHolder(),
    );
  }
}

// @Has()
// typedef ShaftFactories = Singletons<ShaftFactoryKey, ShaftFactory>;

final shaftFactories = Singletons.holder({
  0: InvalidShaftFactory.create(),
  1: MainMenuShaftFactory.create(),
  2: OptionsShaftFactory.create(),
});

ShaftFactoryKey getShaftFactoryKey({
  @Ext() required ShaftFactory shaftFactory,
}) {
  return shaftFactory.singletonKeyHolder.value;
}
