import 'package:mhu_dart_commons/commons.dart';

// part 'bar.freezed.dart';
//
// @freezedStruct
// class BarBits with _$BarBits {
//   BarBits._();
//
//   factory BarBits({
//     required HasSizedWidget primary,
//     @Default([]) List<HasSizedWidget> items,
//   }) = _BarBits;
//
//   SizedWidget widget([double? width]) {
//     if (width == null) {
//       return sizedRow(children: [
//         ...items,
//         primary,
//       ]);
//     }
//
//     Iterable<HasSizedWidget> takeWhatFits() sync* {
//       var remaining = width - primary.width;
//
//       if (remaining <= 0) {
//         return;
//       }
//
//       for (final item in items) {
//         remaining -= item.width;
//         if (remaining >= 0) {
//           yield item;
//         } else {
//           return;
//         }
//       }
//     }
//
//     return sizedRow(children: [
//       ...takeWhatFits(),
//       primary,
//     ]);
//
//   }
// }
