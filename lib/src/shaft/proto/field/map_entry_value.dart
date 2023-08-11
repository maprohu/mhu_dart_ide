part of 'map.dart';

@Compose()
abstract class PfeShaftMapEntryValue<T>
    implements
        ShaftCalcBuildBits,
        EditingShaftContentBits<T>,
        ShaftCalc,
        HasEditScalarShaftBits<T> {
  static PfeShaftMapEntryValue of(ShaftCalcBuildBits shaftCalcBuildBits) {
    final mapEntry = shaftCalcBuildBits.leftCalc as PfeMapEntryShaft;

    final dataType = mapEntry.mapDataType.mapValueDataType;

    final contentBits = switch (dataType) {
      MessageDataType() => dataType.messageDataTypeGeneric(
          <M extends GeneratedMessage>(messageDataType) {
            return MessageEditingShaftContentBits.create<M>(
              editingFw: mapEntry.pfeMapValueFw as Fw<M?>,
              messageDataType: messageDataType,
            );
          },
        ),
      final other => throw other,
    };

    return ComposedPfeShaftMapEntryValue.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      shaftHeaderLabel: shaftCalcBuildBits.defaultShaftHeaderLabel,
      editingShaftContentBits: contentBits,
      editScalarShaftBits: contentBits,
    );
  }
}
