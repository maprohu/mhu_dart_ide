import 'package:flutter/cupertino.dart';
import 'package:mhu_dart_ide/src/builder/shaft.dart';
import 'package:mhu_dart_ide/src/builder/sized.dart';
import 'package:mhu_dart_ide/src/bx/share.dart';
import 'package:mhu_dart_ide/src/bx/string.dart';
import 'package:mhu_dart_ide/src/bx/text.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../../proto.dart';
import 'boxed.dart';

SharingBx notificationSharingBx({
  required SizedShaftBuilderBits sizedShaftBuilderBits,
  required MdiNotificationMsg notificationMsg,
}) {
  final textStyle = sizedShaftBuilderBits.themeCalc.notificationTextStyle;
  final message = notificationMsg.text;

  final textSpan = textStyle.span(message);
  final intrinsicTextSize = textSpan.wrapSize(sizedShaftBuilderBits.width);

  return ComposedSharingBx(
    intrinsicDimension: intrinsicTextSize.height,
    dimensionBxBuilder: (height) {
      final size = sizedShaftBuilderBits.size.withHeight(height);

      return Bx.leaf(
        size: size,
        widget: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width,
            maxHeight: size.height,
          ),
          child: RichText(
            text: textSpan,
            overflow: TextOverflow.fade,
          ),
        ),
      );
    },
  );
}
