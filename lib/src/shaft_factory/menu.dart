part of '../shaft_factory.dart';

CreateShaftContent<D> shaftMenuContent<D>(
  List<MenuItem> Function(
    D shaftData,
    ShaftCtx shaftCtx,
  ) items,
) {
  return (shaftData) {
    return (rectCtx) {
      return [
        menuRectSharingBox(
          rectCtx: rectCtx,
          items: items(shaftData, rectCtx),
        ),
      ];
    };
  };
}
