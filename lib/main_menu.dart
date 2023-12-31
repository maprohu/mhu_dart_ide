part of 'main.dart';

ShaftActions sampleMainMenu(ShaftCtx shaftCtx) {
  return ComposedShaftActions.shaftLabel(
    shaftLabel: stringConstantShaftLabel("Main Menu"),
    callShaftContent: shaftMenuContent((shaftCtx) {
      return [
        mdiShaftOpener<MdiConfigShaftFactory>().shaftOpenerMenuItem(
          shaftCtx: shaftCtx,
        ),
        menuItemStatic(
          action: shaftCtx.windowResetView,
          label: "Reset View",
        ),
      ];
    }),
    callShaftFocusHandler: shaftWithoutFocus,
    callShaftInterface: voidShaftInterface,
    callParseShaftIdentifier: keyOnlyShaftIdentifier,
  );
}
