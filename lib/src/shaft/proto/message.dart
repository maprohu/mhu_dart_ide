import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/bx/menu.dart';
import 'package:mhu_dart_ide/src/screen/opener.dart';
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
abstract class PfeMessageBits implements HasBuildShaftContent {
  static PfeMessageBits create<M extends GeneratedMessage>({
    required MessageEditingBits<M> messageEditingBits,
  }) {
    assert(M != GeneratedMessage);

    late final messageCalc = messageEditingBits.messageDataType.pbiMessageCalc;
    return ComposedPfeMessageBits(
      buildShaftContent: (SizedShaftBuilderBits sizedBits) {
        return sizedBits.menu(
          items: messageCalc.topFieldKeys.map((fieldKey) {
            switch (fieldKey) {
              case ConcreteFieldKey():
                return ShaftTypes.concreteField.opener(
                  sizedBits,
                  shaftKey: (key) => key.tagNumber = fieldKey.tagNumber,
                );
              case OneofFieldKey():
                return ShaftTypes.oneofField.opener(
                  sizedBits,
                  shaftKey: (key) => key.oneofIndex = fieldKey.oneofIndex,
                );
            }
          }).toList(),
        );
      },
    );
  }
}
