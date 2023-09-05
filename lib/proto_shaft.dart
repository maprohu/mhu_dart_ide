part of 'main.dart';

class MdiConfigShaftFactory extends MdiShaftFactory {
  @override
  ShaftActions buildShaftActions(ShaftCtx shaftCtx) {
    final configObj = shaftCtx.mdiConfigObj();
    final messageValue = configObj.mdiConfigWatch;
    final messageCtx =
        configObj.schemaLookupByName.lookupMessageCtxOfType<MdiConfigMsg>();

    late final protoCustomizer = mdiConfigProtoCustomizer();

    late final shaftInterface = ComposedProtoMessageShaftInterface(
      messageCtx: messageCtx,
      messageValue: messageValue,
      protoCustomizer: protoCustomizer,
    );
    return ComposedShaftActions.shaftLabel(
      shaftLabel: stringConstantShaftLabel("MDI Config"),
      callShaftContent: () => protoMessageShaftContent(
        shaftInterface: shaftInterface,
      ),
      callShaftFocusHandler: shaftWithoutFocus,
      callShaftInterface: () => shaftInterface,
      callParseShaftIdentifier: keyOnlyShaftIdentifier,
    );
  }
}

ProtoCustomizer mdiConfigProtoCustomizer() {
  final protoCustomizer = ProtoCustomizer();

  protoCustomizer.logicalFieldVisible.put(
    MdiConfigMsg$.ids,
    (shaftInterface) => false,
  );

  return protoCustomizer;
}
