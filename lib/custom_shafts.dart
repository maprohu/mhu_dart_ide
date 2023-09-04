part of 'main.dart';

ShaftActions mdiCustomShaftActions(ShaftCtx shaftCtx) {
  final shaftIdentifier = shaftCtx.shaftCtxInnerIdentifierMsg();

  return mdiShaftFactories
      .shaftFactoriesLookupKey(
        shaftFactoryKey: shaftIdentifier.shaftFactoryKey,
      )
      .buildShaftActions(shaftCtx)
      .mshCustomShaftActions();
}

abstract class MdiShaftFactory extends ShaftFactory {}

final ShaftFactories mdiShaftFactories = Singletons.mixin({
  0: MdiConfigShaftFactory(),
});

ShaftOpener mdiShaftOpener<F extends MdiShaftFactory>({
  CmnAny? identifierAnyData,
  UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  assert(F != MdiShaftFactory);
  return mdiShaftFactories
      .factoriesShaftOpenerOf<F>(
        identifierAnyData: identifierAnyData,
        updateShaftInnerState: updateShaftInnerState,
      )
      .mshCustomShaftOpener();
}
