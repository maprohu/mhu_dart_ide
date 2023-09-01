part of '../rect.dart';

@Compose()
abstract class MenuItem implements HasWatchAimAction, HasWxRectBuilder {}

SharingBox menuRectSharingBox({
  @ext required RectCtx rectCtx,
  required List<MenuItem> items,
  double? itemHeight,
}) {
  final themeWrap = rectCtx.renderCtxThemeWrap();
  itemHeight ??= themeWrap.menuItemHeight;
  return rectCtx.chunkedRectVerticalSharingBox(
    itemHeight: itemHeight,
    itemCount: items.length,
    startAt: 0,
    itemBuilder: (index, rectCtx) {
      final item = items[index];
      return rectCtx.wxRectPadding(
        padding: themeWrap.menuItemPadding,
        builder: (rectCtx) {
          return rectCtx.wxRectFillRight(
            left: [
              rectCtx.wxRectAimWatch(
                watchAction: item.watchAimAction,
                horizontal: null,
                vertical: AxisAlignment.center,
              ),
            ],
            right: item.wxRectBuilder,
          );
        },
      );
    },
    dividerThickness: themeWrap.menuItemsDividerThickness,
  );
}

MenuItem menuItemStatic({
  required VoidCallback action,
  required String label,
}) {
  return menuItemStaticAction(
    action: action,
    wxRectBuilder: (rectCtx) {
      return wxMenuItemLabelString(
        rectCtx: rectCtx,
        label: label,
      );
    },
  );
}

MenuItem menuItemStaticAction({
  required VoidCallback action,
  required WxRectBuilder wxRectBuilder,
}) {
  return ComposedMenuItem(
    watchAimAction: () => action,
    wxRectBuilder: wxRectBuilder,
  );
}

MenuItem shaftOpenerMenuItem<F extends ShaftFactoryHolder>({
  @ext required ShaftCtx shaftCtx,
  UpdateShaftIdentifier? updateShaftIdentifier,
  UpdateShaftInnerState updateShaftInnerState = shaftEmptyInnerState,
}) {
  final shaftOpener = shaftOpenerOf<F>(
    updateShaftInnerState: updateShaftInnerState,
    updateShaftIdentifier: updateShaftIdentifier,
  );

  final openedShaftCtx = shaftOpener
      .openerShaftMsg()
      .addShaftMsgParent(shaftCtx: shaftCtx)
      .createShaftCtx(
        renderCtx: shaftCtx,
        shaftOnRight: null,
      );

  final shaftObj = openedShaftCtx.shaftObj;

  return menuItemStaticAction(
    action: () {
      shaftOpener.openShaftOpener(
        shaftCtx: shaftCtx,
      );
    },
    wxRectBuilder: shaftObj.shaftFactory.createShaftOpenerLabel(
      shaftObj.shaftData,
    ),
  );
}

TextCtx menuItemText({
  @ext required RectCtx rectCtx,
}) {
  return createTextCtx(
    rectCtx: rectCtx,
    textStyle: rectCtx.renderObj.themeWrap.menuItemTextStyle,
  );
}

Wx wxMenuItemLabelString({
  @ext required RectCtx rectCtx,
  required String label,
}) {
  return rectCtx.menuItemText().wxTextHorizontal(
        text: label,
      );
}
