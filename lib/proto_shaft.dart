part of 'main.dart';

class MdiConfigShaftFactory extends MdiShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    final configObj = shaftCtx.mdiConfigObj();
    final messageValue = configObj.mdiConfigWatch;
    final messageCtx =
        configObj.schemaLookupByName.lookupMessageCtxOfType<MdiConfigMsg>();

    late final shaftInterface = ComposedProtoMessageShaftInterface(
      messageCtx: messageCtx,
      messageValue: messageValue,
    );
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("MDI Config"),
      callShaftContent: () => protoMessageShaftContent(
        messageCtx: messageCtx,
        messageValue: messageValue,
      ),
      callShaftFocusHandler: shaftWithoutFocus,
      callShaftInterface: () => shaftInterface,
      callParseShaftIdentifier: keyOnlyShaftIdentifier,
    );
  }
}
