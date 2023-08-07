import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';

part 'editing.g.has.dart';

part 'editing.g.compose.dart';

@Has()
typedef WatchValue<T> = T Function();
@Has()
typedef ReadValue<T> = T Function();

@Has()
typedef WriteValue<T> = void Function(T value);

@Has()
typedef SaveValue = void Function();

@Compose()
abstract class ReadWrite<T> implements HasReadValue<T>, HasWriteValue<T> {}

@Has()
typedef EditingScalarValue<T> = Fw<T>;
@Has()
typedef EditingMapValue<K, V> = Fu<Map<K, V>>;
@Has()
typedef EditingRepeatedValue<T> = Fu<List<T>>;

@Has()
sealed class EditingValueVariant {}

@Compose()
abstract class EditingScalarValueVariant<T> extends EditingValueVariant
    implements HasEditingScalarValue<T> {}

@Compose()
abstract class EditingMapValueVariant<K, V> extends EditingValueVariant
    implements HasEditingMapValue<K, V> {}

@Compose()
abstract class EditingRepeatedValueVariant<T> extends EditingValueVariant
    implements HasEditingRepeatedValue<T> {}
