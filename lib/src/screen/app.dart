import 'dart:ui';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import '../app.dart';
import '../bx/divider.dart';
import '../bx/screen.dart';

part 'app.freezed.dart';

class MdiApp extends StatelessWidget {
  final AppBits appBits;

  final WatchValue<BeforeAfter<ShaftsLayout>> shaftsLayout;

  MdiApp({
    super.key,
    required this.appBits,
    required this.shaftsLayout,
  });

  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: appBits.opBuilder.onKeyEvent,
      child: MaterialApp(
        title: "MHU Dart IDE",
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        shortcuts: const {},
        home: Scaffold(
          body: flcFrr(watchWidget),
        ),
      ),
    );
  }

  Widget watchWidget() {
    final (
      :before,
      :after,
    ) = shaftsLayout();

    if (after.shafts.isEmpty) {
      return busyWidget;
    }

    final animations = shaftAnimations(
      before: before,
      after: after,
    );

    // Widget? Function(double animation) moveCalc = (_) {
    //   return null;
    // };

    double calcDividerThickness(double animation) {
      return lerpDouble(
        before.dividerThickness,
        after.dividerThickness,
        animation,
      )!;
    }

    Widget calcDividerWidget(double dividerThickness) {
      return verticalDividerBx(
        thickness: dividerThickness,
        height: after.screenSize.height,
      ).layout();
    }

    final movedWidgets = animations.moved.map((e) {
      return (
        before: e.before.shaftBx.sizedLayout(),
        after: e.after.shaftBx.sizedLayout(),
      );
    }).toList();

    final screenWidth = after.screenSize.width;
    final screenHeight = after.screenSize.height;

    final positionBeforeAfter = animations.positionBeforeAfter;

    final beforeCalc = AnimationsMoveCalc(
      startPositionDelta: positionBeforeAfter.before,
      dividerThickness: before.dividerThickness,
      shafts: animations.moved.map((e) => e.before).toList(),
      screenWidth: screenWidth,
      totalShaftWidth: before.totalShaftWidth,
    );
    final afterCalc = AnimationsMoveCalc(
      startPositionDelta: positionBeforeAfter.after,
      dividerThickness: after.dividerThickness,
      shafts: animations.moved.map((e) => e.after).toList(),
      screenWidth: screenWidth,
      totalShaftWidth: after.totalShaftWidth,
    );

    final dividerAnimations = zip2IterablesRecords(
      beforeCalc.dividerPositions,
      afterCalc.dividerPositions,
    ).map((e) {
      final (before, after) = e;
      return DoubleAnimation(before: before, after: after);
    }).toIList();

    final addedWidgets = animations.added.map((e) => e.shaftBx.layout());
    final removedWidgets = animations.removed.map((e) => e.shaftBx.layout());

    Widget rightWidgets({
      required double opacity,
      required Widget divider,
      required Iterable<Widget> children,
    }) {
      return Opacity(
        opacity: opacity,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: children.separatedBy(divider).toList(),
        ),
      );
    }

    return flcAnimate(
      builder: (animation) {
        final dividerThickness = calcDividerThickness(animation);
        final divider = calcDividerWidget(dividerThickness);

        final dividerThicknessHalf = dividerThickness / 2;

        final currentDividerPositions =
            dividerAnimations.map((e) => e.lerp(animation)).toList();

        final shaftWidths = <double>[];
        final firstDividerPosition = currentDividerPositions.first;
        var previousDividerPosition = firstDividerPosition;

        for (final dividerPosition in currentDividerPositions.skip(1)) {
          shaftWidths.add(
            dividerPosition - previousDividerPosition - dividerThickness,
          );
          previousDividerPosition = dividerPosition;
        }

        final currentMovedWidgets = zip2IterablesRecords(
          movedWidgets,
          shaftWidths,
        ).map<Widget>((e) {
          final (widgets, width) = e;

          return Stack(
            children: [
              SizedBox(
                width: width,
                height: screenHeight,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: widgets.before,
                ),
              ),
              Opacity(
                opacity: animation,
                child: SizedBox(
                  width: width,
                  height: screenHeight,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: widgets.after,
                  ),
                ),
              ),
            ],
          );
        }).expand(
          (element) => [
            element,
            divider,
          ],
        );

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: firstDividerPosition + dividerThicknessHalf,
              child: Row(
                children: [
                  ...currentMovedWidgets,
                  Stack(
                    children: [
                      rightWidgets(
                        opacity: 1 - animation,
                        divider: divider,
                        children: removedWidgets,
                      ),
                      rightWidgets(
                        opacity: animation,
                        divider: divider,
                        children: addedWidgets,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  ShaftAnimations shaftAnimations({
    required ShaftsLayout before,
    required ShaftsLayout after,
  }) {
    late int positionDelta;
    final moved = <ShaftAnimationMove>[];

    void leftInOrOut({
      required List<ShaftLayout> shafts,
    }) {
      for (final shaft in shafts) {
        moved.add(
          ShaftAnimationMove(
            before: shaft,
            after: shaft,
          ),
        );
      }
    }

    var beforeShafts = before.shafts.toList();
    var afterShafts = after.shafts.toList();

    if (beforeShafts.isNotEmpty) {
      final beforeFirstSeq = beforeShafts.first.shaftSeq;
      final afterFirstSeq = afterShafts.first.shaftSeq;

      if (beforeFirstSeq < afterFirstSeq) {
        // moved left

        final movedOutLeftCount = beforeShafts
            .takeWhile((value) => value.shaftSeq < afterFirstSeq)
            .length;

        final movedOutLeftList = beforeShafts.sublist(0, movedOutLeftCount);

        positionDelta = -movedOutLeftList.sumBy((e) => e.shaftWidth);
        leftInOrOut(
          shafts: movedOutLeftList,
        );

        beforeShafts = beforeShafts.sublist(movedOutLeftCount);
      } else {
        // moved right

        final movedInFromLeftCount = afterShafts
            .takeWhile((value) => value.shaftSeq < beforeFirstSeq)
            .length;

        final movedInFromLeftList =
            afterShafts.sublist(0, movedInFromLeftCount);

        positionDelta = movedInFromLeftList.sumBy((e) => e.shaftWidth);
        leftInOrOut(
          shafts: movedInFromLeftList,
        );

        afterShafts = afterShafts.sublist(movedInFromLeftCount);
      }
    } else {
      positionDelta = 0;
    }

    final beforeAfterZipped = zip2Iterables(beforeShafts, afterShafts).toList();

    final movedWithinScreenList = beforeAfterZipped.takeWhileNotNull(
      (value) {
        switch (value) {
          case Zip2Both(:final left, :final right):
            if (left.shaftSeq == right.shaftSeq) {
              return value;
            }
          default:
        }
        return null;
      },
    ).toList();

    for (final zip in movedWithinScreenList) {
      moved.add(
        ShaftAnimationMove(
          before: zip.left,
          after: zip.right,
        ),
      );
    }

    final removedOrAdded = beforeAfterZipped.sublist(
      movedWithinScreenList.length,
    );

    return ShaftAnimations(
      positionDelta: positionDelta,
      moved: moved,
      removed: removedOrAdded.takeWhileNotNull((e) => e.leftOrNull).toList(),
      added: removedOrAdded.takeWhileNotNull((e) => e.rightOrNull).toList(),
    );
  }
}

@freezedStruct
class DoubleAnimation with _$DoubleAnimation {
  DoubleAnimation._();

  factory DoubleAnimation({
    required double before,
    required double after,
  }) = _DoubleAnimation;
}

extension DoubleAnimationX on DoubleAnimation {
  double lerp(double t) => lerpDouble(before, after, t)!;
}

@freezedStruct
class ShaftAnimations with _$ShaftAnimations {
  ShaftAnimations._();

  factory ShaftAnimations({
    required int positionDelta,
    required List<ShaftAnimationMove> moved,
    required List<ShaftLayout> added,
    required List<ShaftLayout> removed,
  }) = _ShaftAnimations;

  BeforeAfter<int> get positionBeforeAfter {
    if (positionDelta < 0) {
      return (
        before: 0,
        after: positionDelta,
      );
    } else {
      return (
        before: -positionDelta,
        after: 0,
      );
    }
  }
}

@freezedStruct
class ShaftAnimationMove with _$ShaftAnimationMove {
  ShaftAnimationMove._();

  factory ShaftAnimationMove({
    required ShaftLayout before,
    required ShaftLayout after,
  }) = _ShaftAnimationMove;
}

class AnimationsMoveCalc {
  final int startPositionDelta;
  final double dividerThickness;
  final List<ShaftLayout> shafts;
  final double screenWidth;
  final int totalShaftWidth;

  late final availableWidthPlusDivider = screenWidth + dividerThickness;

  late final shaftUnitWidthPlusDivider =
      availableWidthPlusDivider / totalShaftWidth;

  late final dividerHalfThickness = dividerThickness / 2;

  late final dividerPositions = run(() {
    var actualPosition =
        startPositionDelta * shaftUnitWidthPlusDivider - dividerHalfThickness;
    final positions = [actualPosition];

    for (final shaft in shafts) {
      final shaftWidth = shaftUnitWidthPlusDivider * shaft.shaftWidth;
      actualPosition += shaftWidth;
      positions.add(actualPosition);
    }

    return positions.toIList();
  });

  AnimationsMoveCalc({
    required this.startPositionDelta,
    required this.dividerThickness,
    required this.shafts,
    required this.screenWidth,
    required this.totalShaftWidth,
  });
}
