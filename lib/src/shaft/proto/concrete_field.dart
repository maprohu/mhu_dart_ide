import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/config.dart';
import 'package:mhu_dart_ide/src/op.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

part 'concrete_field.g.has.dart';
part 'concrete_field.g.compose.dart';

@Has()
@Compose()
abstract class ConcreteFieldShaftRight {}

@Compose()
abstract class ConcreteFieldShaftMerge implements ShaftMergeBits {}

@Compose()
abstract class ConcreteFieldShaft
    implements
        ShaftCalcBuildBits,
        ConcreteFieldShaftMerge,
        ConcreteFieldShaftRight,
        ShaftCalc {
  static ConcreteFieldShaft create(
    ShaftCalcBuildBits shaftCalcBuildBits,
  ) {
    final left = shaftCalcBuildBits.leftCalc as HasMessageEditingBits;
    final tagNumber = shaftCalcBuildBits.shaftMsg.shaftIdentifier.concreteField.tagNumber;
    final messageType = left.messageEditingBits.messageDataType.pbiMessage.messageType;

    final fieldKey = ConcreteFieldKey(
      messageType: messageType,
      tagNumber: tagNumber,
    );

    final fieldCalc = fieldKey.concreteFieldCalc;

    final shaftRight = ComposedConcreteFieldShaftRight();
    final shaftMerge = ComposedConcreteFieldShaftMerge(
      shaftHeaderLabel: fieldCalc.protoName,
      buildShaftContent: (sizedBits) {
        throw "todo";
      },
    );

    return ComposedConcreteFieldShaft.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      concreteFieldShaftMerge: shaftMerge,
      concreteFieldShaftRight: shaftRight,
    );
  }
}



// import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
// import 'package:mhu_dart_commons/commons.dart';
// import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
// import 'package:mhu_dart_ide/src/shaft/proto/field/map.dart';
// import 'package:mhu_dart_ide/src/shaft/proto/field/scalar.dart';
// import 'package:mhu_dart_ide/src/shaft/proto/message.dart';
// import 'package:mhu_dart_proto/mhu_dart_proto.dart';
// import 'package:protobuf/protobuf.dart';
//
// import '../../app.dart';
// import '../../config.dart';
// import '../../op.dart';
// import '../../screen/calc.dart';
// import '../../screen/inner_state.dart';
//
// part 'concrete_field.g.has.dart';
//
// part 'concrete_field.g.compose.dart';
//
// @Compose()
// abstract class PfeShaftConcreteFieldBits
//     implements ShaftCalcBuildBits, HasConcreteFieldKey, HasShaftHeaderLabel {}
//
// @Compose()
// @Has()
// abstract class PfeShaftConcreteField implements ShaftCalcBits, ShaftCalc {
//   static PfeShaftConcreteField of(
//     ShaftCalcBuildBits shaftCalcBuildBits,
//   ) {
//     final leftCalc = shaftCalcBuildBits.leftCalc as HasEditScalarShaftBits;
//
//     final messageEditingBits =
//         leftCalc.editScalarShaftBits as MessageEditingBits;
//
//     final shaftValue = shaftCalcBuildBits.shaftMsg.pfeConcreteField;
//     final concreteFieldKey = ConcreteFieldKey(
//       messageType: messageEditingBits.messageDataType.pbiMessage.messageType,
//       tagNumber: shaftValue.tagNumber,
//     );
//
//     final concreteFieldCalc = concreteFieldKey.concreteFieldCalc;
//
//     final pfeShaftConcreteFieldBits =
//         ComposedPfeShaftConcreteFieldBits.shaftCalcBuildBits(
//       shaftCalcBuildBits: shaftCalcBuildBits,
//       concreteFieldKey: concreteFieldKey,
//       shaftHeaderLabel: concreteFieldCalc.protoName,
//     );
//
//     final dataType = concreteFieldCalc.dataType;
//
//     return switch (dataType) {
//       MapDataType() => PfeShaftMapField.of(
//           pfeShaftConcreteFieldBits: pfeShaftConcreteFieldBits,
//           concreteFieldCalc: concreteFieldCalc,
//           mapDataType: dataType,
//           messageEditingBits: messageEditingBits,
//         ),
//       ScalarDataType() => dataType.scalarDataTypeGeneric(<T>(scalarDataType) {
//           return PfeShaftScalarField.create(
//             pfeShaftConcreteFieldBits: pfeShaftConcreteFieldBits,
//             scalarDataType: scalarDataType,
//             messageEditingBits: messageEditingBits,
//           );
//         }),
//       _ => throw dataType,
//     };
//   }
// }
//
// @Has()
// typedef ConcreteFieldFr<T> = Fr<T>;
// @Has()
// typedef ScalarFieldFw<T> = Fw<T>;
// @Has()
// typedef CollectionFieldFu<T> = Fu<T>;
//
// @Compose()
// abstract class PfeShaftConcreteFieldVariant<T>
//     implements
//         ShaftCalcBits,
//         HasBuildShaftContent,
//         HasBuildShaftOptions,
//         HasPfeFieldValue<T> {}
//
// @Has()
// sealed class PfeFieldValue<T> implements HasConcreteFieldFr<T> {}
//
// @Compose()
// abstract class PfeMapFieldValue<M extends GeneratedMessage, K, V>
//     implements
//         PfeFieldValue<Map<K, V>>,
//         HasCollectionFieldFu<Map<K, V>>,
//         HasMapFieldAccess<M, K, V> {}
//
// // abstract class ConcreteFieldOptions {
// //   final PfeConcreteFieldShaftCalc shaftCalc;
// //
// //   ConcreteFieldOptions(this.shaftCalc);
// //
// //   List<MenuItem> options(ShaftBuilderBits shaftBits);
// // }
// //
// // class _TodoOptions extends ConcreteFieldOptions {
// //   _TodoOptions(super.shaftCalc);
// //
// //   @override
// //   List<MenuItem> options(ShaftBuilderBits nodeBits) {
// //     return [];
// //   }
// // }
// //
// // @Has()
// // abstract class ConcreteFieldVariant {}
