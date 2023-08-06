part of 'map.dart';

@Has()
typedef PfeMapKeyFw<K> = Fw<K>;
@Has()
typedef PfeMapValueFw<V> = Fw<V>;

@Compose()
abstract class PfeMapEntryBits implements HasPfeMapKeyFw, HasPfeMapValueFw {}

abstract class PfeMapEntryShaft
    implements PfeMapFieldBits, PfeMapEntryBits, ShaftCalc {}
