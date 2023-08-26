import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_shafts/src/context/rect.dart';
import 'package:mhu_shafts/src/shaft/error.dart';
import 'package:mhu_shafts/src/shaft/main_menu.dart';
import 'package:mhu_shafts/src/shaft/options.dart';
import 'package:mhu_shafts/src/wx/wx.dart';

import 'shaft_factory.dart' as $lib;

part 'shaft_factory.g.has.dart';

part 'shaft_factory.g.dart';

part 'shaft_factory/label.dart';

part 'shaft_factory/data.dart';

part 'shaft_factory/focus.dart';
part 'shaft_factory/menu.dart';

typedef ShaftFactoryKey = int;

@Has()
typedef CreateShaftData<D> = D Function(ShaftCtx shaftCtx);

@Has()
typedef CreateShaftHeaderLabel<D> = WxRectBuilder Function(D shaftData);

@Has()
typedef CreateShaftOpenerLabel<D> = WxRectBuilder Function(D shaftData);

@Has()
@HasDefault(shaftWithoutFocus)
typedef RequestShaftFocus<D> = HandlePressedKey? Function(D shaftData);

@Has()
typedef CreateShaftContent<D> = BuildSharingBoxes Function(D shaftData);

@Compose()
abstract class ShaftLabel<D>
    implements HasCreateShaftHeaderLabel<D>, HasCreateShaftOpenerLabel<D> {}

@Compose()
abstract class ShaftFactory<D>
    implements
        ShaftLabel<D>,
        HasCreateShaftData<D>,
        HasCreateShaftHeaderLabel<D>,
        HasCreateShaftOpenerLabel<D>,
        HasRequestShaftFocus<D>,
        HasCreateShaftContent<D> {}

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
      shaftFactories.lookupSingletonByType<InvalidShaftFactory>().buildShaftActions;
}

F shaftFactoryOf<F extends ShaftFactoryHolder>() {
  return shaftFactories.lookupSingletonByType<F>();
}

ShaftFactoryKey shaftFactoryKeyOf<F extends ShaftFactoryHolder>() {
  return shaftFactoryOf<F>().singletonKey;
}
