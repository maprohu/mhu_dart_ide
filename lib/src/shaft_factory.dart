import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/context/rect.dart';
import 'package:mhu_dart_ide/src/shaft/error.dart';
import 'package:mhu_dart_ide/src/shaft/main_menu.dart';
import 'package:mhu_dart_ide/src/shaft/options.dart';

import 'shaft_factory.dart' as $lib;

part 'shaft_factory.g.has.dart';

part 'shaft_factory.g.dart';

part 'shaft_factory/label.dart';

part 'shaft_factory/data.dart';
part 'shaft_factory/focus.dart';

typedef ShaftFactoryKey = int;

@Has()
typedef CreateShaftData<D> = D Function(ShaftCtx shaftCtx);

@Has()
typedef CreateShaftHeaderLabel<D> = WxRectBuilder Function(D shaftData);

@Has()
typedef ShaftNeedsFocus<D> = bool Function(D shaftData);

@Compose()
abstract class ShaftFactory<D>
    implements
        HasCreateShaftData<D>,
        HasCreateShaftHeaderLabel<D>,
        HasShaftNeedsFocus<D> {}

abstract class ShaftFactoryHolder with MixSingletonKey<ShaftFactoryKey> {
  ShaftFactory get factory;
}

final shaftFactories = Singletons.mixin<ShaftFactoryKey, ShaftFactoryHolder>({
  0: InvalidShaftFactory(),
  1: MainMenuShaftFactory(),
  2: OptionsShaftFactory(),
});

ShaftFactoryKey getShaftFactoryKey({
  @Ext() required ShaftFactoryHolder shaftFactory,
}) {
  return shaftFactory.singletonKey;
}

ShaftFactory lookupShaftFactory({
  required ShaftFactoryKey shaftFactoryKey,
}) {
  return shaftFactories.singletonsByKey[shaftFactoryKey]?.factory ??
      shaftFactories.lookupSingletonByType<InvalidShaftFactory>().factory;
}
