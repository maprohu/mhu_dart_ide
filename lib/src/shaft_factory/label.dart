part of '../shaft_factory.dart';

CreateShaftHeaderLabel staticShaftHeaderLabel(String label) {
  return stringShaftHeaderLabel(
    (shaftData) => label,
  );
}

CreateShaftHeaderLabel<D> stringShaftHeaderLabel<D>(
  String Function(D shaftData) label,
) {
  return (shaftData) {
    final string = label(shaftData);
    return (rectCtx) {
      return rectCtx.wxShaftHeaderLabelString(
        label: string,
      );
    };
  };
}

ShaftLabel<D> staticShaftLabel<D>(
  String label,
) {
  return stringShaftLabel(
    (shaftData) => label,
  );
}

ShaftLabel<D> stringShaftLabel<D>(
  String Function(D shaftData) label,
) {
  return ComposedShaftLabel(
    createShaftHeaderLabel: stringShaftHeaderLabel(label),
    createShaftOpenerLabel: stringShaftOpenerLabel(label),
  );
}

CreateShaftOpenerLabel<D> stringShaftOpenerLabel<D>(
  String Function(D shaftData) label,
) {
  return (shaftData) {
    final string = label(shaftData);
    return (rectCtx) {
      return rectCtx.wxMenuItemLabelString(
        label: string,
      );
    };
  };
}
