import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/screen/calc.dart';
import 'package:mhu_dart_ide/src/shaft/proto/concrete_field.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

import '../../../../proto.dart';
import '../../../app.dart';
import '../../../bx/menu.dart';
import '../../../config.dart';
import '../../../op.dart';
import '../scalar/int.dart';
import '../scalar/string.dart';

part 'map.g.has.dart';

part 'map.g.compose.dart';

part 'map_entry.dart';
part 'map_entry_new.dart';
part 'map_entry_key.dart';
part 'map_entry_value.dart';

@Has()
typedef PfeMapFieldFu<K, V> = Fu<Map<K, V>>;

@Compose()
abstract class PfeMapFieldBits<M extends GeneratedMessage, K, V>
    implements
        PfeMapKeyBits,
        PfeMapValueBits,
        HasMapFieldAccess<M, K, V>,
        HasPfeMapFieldFu<K, V> {}


@Compose()
abstract class PfeMapKeyBits implements HasDefaultPbMapKey {}

@Compose()
abstract class PfeMapValueBits {}

@Compose()
abstract class PfeShaftMapField
    implements
        PfeShaftConcreteFieldBits,
        PfeMapFieldBits,
        ShaftCalc,
        PfeShaftConcreteField
{
  static PfeShaftMapField of({
    required PfeShaftConcreteFieldBits pfeShaftConcreteFieldBits,
    required MapFieldAccess mapFieldAccess,
    required Mfw mfw,
  }) {
    final mapFieldBits = ComposedPfeMapFieldBits.merge$(
      pfeMapKeyBits: ComposedPfeMapKeyBits(
        defaultPbMapKey: mapFieldAccess.defaultMapKey,
      ),
      pfeMapValueBits: ComposedPfeMapValueBits(),
      mapFieldAccess: mapFieldAccess,
      pfeMapFieldFu: mapFieldAccess.fuCold(mfw),
    );

    return ComposedPfeShaftMapField.merge$(
      pfeShaftConcreteFieldBits: pfeShaftConcreteFieldBits,
      pfeMapFieldBits: mapFieldBits,
      buildShaftContent: (sizedBits) => sizedBits.fill(),
      buildShaftOptions: (shaftBits) {
        return [
          shaftBits.openerField(MdiShaftMsg$.newMapItem),
        ];
      },
    );
  }
}




