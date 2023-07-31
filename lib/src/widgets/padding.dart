import 'package:flutter/cupertino.dart';
import 'package:mhu_dart_ide/src/screen.dart';
import 'package:mhu_dart_ide/src/widgets/sized.dart';

SizedWidget buildSizedPadding({
  required EdgeInsets padding,
  required Size size,
  required NodeBuilder builder,
  required NodeBuilderBits nodeBits,
}) {
  final innerSize = Size(
    size.width - padding.horizontal,
    size.height - padding.vertical,
  );

  return Padding(
    padding: padding,
    child: builder(
      nodeBits.sized(innerSize),
    ),
  ).sizedWith(size);
}
