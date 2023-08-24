part of '../shaft_factory.dart';

CreateShaftHeaderLabel staticShaftHeaderLabel(String label) {
  return (shaftData) {
    return (rectCtx) {
      return rectCtx.wxShaftHeaderLabelString(
        label: label,
      );
    };
  };
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
