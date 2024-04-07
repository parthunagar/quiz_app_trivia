import 'package:flutter/material.dart';
import 'package:flutterquiz/ui/widgets/circularImageContainer.dart';
import 'package:flutterquiz/ui/widgets/circularTimerContainer.dart';
import 'package:flutterquiz/utils/constants/fonts.dart';

const timerHeightAndWidthPercentage = 0.14;

class UserDetailsWithTimerContainer extends StatelessWidget {
  final String profileUrl;
  final String correctAnswers;
  final String name;
  final AnimationController timerAnimationController;
  final bool isCurrentUser;

  const UserDetailsWithTimerContainer({
    super.key,
    required this.name,
    required this.timerAnimationController,
    required this.profileUrl,
    required this.correctAnswers,
    required this.isCurrentUser,
  });

  Widget _buildTimer(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 55,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularTimerContainer(
                  timerAnimationController: timerAnimationController,
                  heightAndWidth: 50,
                ),
                CircularImageContainer(
                  height: 47,
                  imagePath: profileUrl,
                  width: 47,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 15,
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(
                '$correctAnswers/10',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 10,
                  fontWeight: FontWeights.regular,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeights.bold,
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("$name: $correctAnswers");
    return SizedBox(
      width: 75,
      height: 75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimer(context),
          _buildUserDetails(context),
        ],
      ),
    );
  }
}
