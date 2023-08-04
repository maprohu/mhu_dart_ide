import 'package:mhu_dart_commons/commons.dart';

mixin HasEditingValueOf<T> {
  ReadWrite<T> get editingValue;
}

// generation:

// declare:

@Delegate()
typedef ReadValue<T> = T Function();

@Delegate()
typedef WriteValue<T> = void Function(T value);

@Delegate()
typedef SaveValue = void Function();

// result:

abstract class HasReadValue<T> {
  ReadValue<T> get readValue;
}

class DelegatedReadValue<T> implements HasReadValue<T> {
  @override
  final ReadValue<T> readValue;

  const DelegatedReadValue(this.readValue);
}

abstract class HasWriteValue<T> {
  WriteValue<T> get writeValue;
}

abstract class HasSaveValue {
  SaveValue get saveValue;
}

// declare:

@Delegate()
abstract class ReadWrite<T> implements HasReadValue<T>, HasWriteValue<T> {}

// result:

abstract class HasReadWrite<T> {
  ReadWrite<T> get readWrite;
}

mixin DelegatedReadWriteMixin<T> implements HasReadWrite<T>, ReadWrite<T> {
  @override
  ReadWrite<T> get readWrite;

  @override
  late final readValue = readWrite.readValue;

  @override
  late final writeValue = readWrite.writeValue;
}

class DelegatedReadWrite<T> with DelegatedReadWriteMixin<T> {
  @override
  final ReadWrite<T> readWrite;

  DelegatedReadWrite(this.readWrite);
}

class ComposedReadWrite<T> implements ReadWrite<T> {
  @override
  final ReadValue<T> readValue;

  @override
  final WriteValue writeValue;

  const ComposedReadWrite({
    required this.readValue,
    required this.writeValue,
  });
}

// declare:

abstract class ReadWriteSave<T> implements ReadWrite<T>, HasSaveValue {}
