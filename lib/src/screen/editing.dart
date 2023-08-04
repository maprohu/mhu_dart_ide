import 'package:mhu_dart_commons/commons.dart';

part 'editing.g.has.dart';

part 'editing.g.compose.dart';

@Has()
typedef ReadValue<T> = T Function();

@Has()
typedef WriteValue<T> = void Function(T value);

@Has()
typedef SaveValue = void Function();

@Compose()
abstract class ReadWrite<T> implements HasReadValue<T>, HasWriteValue<T> {}

@Compose()
@Has()
abstract class EditingValue<T> implements ReadWrite<T> {}

