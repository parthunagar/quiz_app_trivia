import 'package:flutter/material.dart';
import 'package:flutterquiz/ui/styles/colors.dart';
import 'package:flutterquiz/utils/ui_utils.dart';

class HorizontalTimerContainer extends StatelessWidget {
  final AnimationController timerAnimationController;

  const HorizontalTimerContainer(
      {super.key, required this.timerAnimationController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          alignment: Alignment.topRight,
          height: 10.0,
          width: MediaQuery.of(context).size.width *
              (UiUtils.questionContainerWidthPercentage - 0.1),
        ),
        AnimatedBuilder(
          animation: timerAnimationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                  color: timerAnimationController.value >= 0.8
                      ? hurryUpTimerColor
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              alignment: Alignment.topRight,
              height: 10.0,
              width: MediaQuery.of(context).size.width *
                  (UiUtils.questionContainerWidthPercentage - 0.1) *
                  (1.0 - timerAnimationController.value),
            );
          },
        ),
      ],
    );
  }
}
