part of '../shaft.dart';

ShaftLayout renderShaft({
  @Ext() required RectCtx rectCtx,
}) {
  final shaftObj = rectCtx.shaftObj;
  // final headerExtra = rectCtx.shaftObj.indexFromRight == 0
  //     ? longRunningTaskIndicatorIcon(
  //         appBits: sizedBits,
  //       )
  //     : null;

  final themeWrap = rectCtx.renderObj.themeWrap;

  final optionsOpener = shaftOpenerOf<OptionsShaftFactory>();

  final headerWx = rectCtx
      .rectWithHeight(height: themeWrap.shaftHeaderOuterHeight)
      .wxRectPadding(
        padding: themeWrap.shaftHeaderPadding,
        builder: (rectCtx) {
          return rectCtx.wxRectFillLeft(
            left: (rectCtx) {
              return shaftObj.shaftFactory
                  .createShaftHeaderLabel(shaftObj.shaftData)
                  .call(rectCtx);
            },
            right: [
              rectCtx
                  .wxRectAim(
                    action: () {
                      optionsOpener.openShaftOpener(
                        shaftCtx: rectCtx,
                      );
                    },
                    horizontal: null,
                    vertical: AxisAlignment.center,
                  )
                  .wxDecorateShaftOpener(
                    shaftOpener: optionsOpener,
                    shaftCtx: rectCtx,
                  ),
            ],
          );
        },
      );

  final wx = rectCtx.wxRectFillBottom(
    top: [
      headerWx,
      rectCtx.wxRectVerticalLayoutDivider(
        thickness: themeWrap.shaftHeaderDividerThickness,
      ),
    ],
    bottom: (rectCtx) {
      return rectCtx.wxEmpty();
    },
  ).wxBackgroundColor(
    color: themeWrap.shaftBackgroundColor,
  );
  final shaftMsg = shaftObj.shaftMsg;
  return ShaftLayout(
    shaftSeq: shaftMsg.shaftSeq,
    shaftWidthUnits: shaftObj.visibleWidthUnits,
    wx: wx,
  );
}

// Bx shaftBx({
//   required RectCtx rectCtx,
// }) {
//   final SizedShaftBuilderBits(
//     :size,
//     :width,
//     :height,
//     :themeCalc,
//   ) = sizedBits;
//
//   final ThemeWrap(
//     :shaftHeaderDividerThickness,
//     :shaftHeaderWithDividerHeight,
//     :shaftHeaderPadding,
//     :shaftHeaderContentHeight,
//     :shaftHeaderOuterHeight,
//   ) = themeCalc;
//
//   final headerContentWidth = width - shaftHeaderPadding.horizontal;
//   final contentHeight = height - shaftHeaderWithDividerHeight;
//
//   final parts = builder(
//     sizedBits.withSize(Size(headerContentWidth, shaftHeaderContentHeight)),
//     sizedBits.withSize(Size(width, contentHeight)),
//   );
//
//   return Bx.col(
//     size: size,
//     rows: [
//       Bx.pad(
//         padding: shaftHeaderPadding,
//         child: parts.header,
//         size: size.withHeight(shaftHeaderOuterHeight),
//       ),
//       horizontalDividerBx(
//         thickness: shaftHeaderDividerThickness,
//         width: width,
//       ),
//       parts.content,
//     ],
//     backgroundColor: themeCalc.shaftBackgroundColor,
//   );
// }
//
// Bx defaultShaftBx({
//   required SizedShaftBuilderBits sizedBits,
//   Bx? headerExtra,
// }) {
//   return shaftBx(
//     sizedBits: sizedBits,
//     builder: (headerBits, contentBits) {
//       final content = contentBits.buildShaftContent(contentBits);
//       final options = contentBits.buildShaftOptions(contentBits);
//
//       final contentSharing = sharedLayoutBx(
//         size: contentBits.size,
//         axis: Axis.vertical,
//         items: [
//           ...content,
//           for (final notification in contentBits
//                   .notificationsFw()
//                   .byIndexFromLeft[
//                       contentBits.shaftCalcChain.shaftIndexFromLeft]
//                   ?.notifications ??
//               [])
//             notificationSharingBx(
//               sizedShaftBuilderBits: contentBits,
//               notificationMsg: notification,
//             ),
//           if (options.isNotEmpty) contentBits.menu(options),
//         ],
//         dividerThickness: contentBits.themeCalc.shaftSharingDividerThickness,
//       );
//
//       return ShaftParts(
//         header: headerBits.fillLeft(
//           left: (sizedBits) {
//             return sizedBits.fillLeft(
//               left: (sizedBits) => sizedBits.headerText.centerLeft(
//                 sizedBits.shaftHeaderLabel,
//               ),
//               right: headerExtra,
//             );
//           },
//           right: headerBits.centerHeight(
//             ShaftTypes.options.openerShortcut(headerBits),
//           ),
//         ),
//         content: contentSharing,
//       );
//     },
//   );
// }
