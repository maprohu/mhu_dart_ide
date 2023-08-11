import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/shaft/editing/editing.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';
import 'package:recase/recase.dart';
import '../../app.dart';
import '../../builder/sized.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';

import '../../config.dart';
import '../../op.dart';

// part 'message.g.has.dart';
part 'message.g.compose.dart';

@Compose()
abstract class PfeMessageShaftCalc<M extends GeneratedMessage>
    implements
        ShaftCalcBuildBits,
        MessageEditingShaftContentBits<M>,
        ShaftCalc,
        HasEditScalarShaftBits<M> {
  static PfeMessageShaftCalc of<M extends GeneratedMessage>({
    required ShaftCalcBuildBits shaftCalcBuildBits,
    required Fw<M> mfw,
  }) {
    assert(M != GeneratedMessage);

    late final pbi = mfw.read().pbi;
    late final messageCalc = pbi.calc;

    final contentBits = MessageEditingShaftContentBits.create(
      editingFw: mfw,
      messageDataType: messageCalc.messageDataType,
    );
    return ComposedPfeMessageShaftCalc.merge$(
      shaftCalcBuildBits: shaftCalcBuildBits,
      messageEditingShaftContentBits: contentBits,
      shaftHeaderLabel: messageCalc.messageName.titleCase,
      editScalarShaftBits: contentBits,
    );
  }
}

@Compose()
abstract class MessageEditingShaftContentBits<M extends GeneratedMessage>
    implements EditingShaftContentBits<M>, MessageEditingBits<M> {
  static MessageEditingShaftContentBits create<M extends GeneratedMessage>({
    required Fw<M?> editingFw,
    required MessageDataType messageDataType,
  }) {
    assert(M != GeneratedMessage);

    late final messageCalc = messageDataType.pbiMessageCalc;
    return ComposedMessageEditingShaftContentBits.messageEditingBits(
      messageEditingBits: MessageEditingBits.create(
        editingFw: editingFw,
        messageDataType: messageDataType,
      ),
      buildShaftContent: (SizedShaftBuilderBits sizedBits) {
        return sizedBits.menu(
          items: messageCalc.topFieldKeys.map((fieldKey) {
            switch (fieldKey) {
              case ConcreteFieldKey():
                return sizedBits.opener(
                  (shaft) {
                    shaft.ensurePfeConcreteField().tagNumber =
                        fieldKey.tagNumber;
                  },
                  label: fieldKey.concreteFieldCalc.protoName,
                );
              case OneofFieldKey():
                return sizedBits.opener(
                  (shaft) {
                    shaft.ensurePfeOneofField().oneofIndex =
                        fieldKey.oneofIndex;
                  },
                  label: fieldKey.calc.name,
                );
            }
          }).toList(),
        );
      },
    );
  }
}
