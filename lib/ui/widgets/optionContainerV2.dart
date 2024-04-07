import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutterquiz/features/quiz/models/answerOption.dart';
import 'package:flutterquiz/features/quiz/models/quizType.dart';
import 'package:flutterquiz/features/settings/settingsCubit.dart';
import 'package:flutterquiz/ui/styles/colors.dart';
import 'package:flutterquiz/utils/constants/constants.dart';
import 'package:flutterquiz/utils/constants/fonts.dart';
import 'package:flutterquiz/utils/ui_utils.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionContainerV2 extends StatefulWidget {
  final Function hasSubmittedAnswerForCurrentQuestion;
  final Function submitAnswer;
  final AnswerOption answerOption;
  final BoxConstraints constraints;
  final String correctOptionId;
  final String submittedAnswerId;
  final bool showAudiencePoll;
  final int? audiencePollPercentage;
  final bool showAnswerCorrectness;
  final QuizTypes quizType;
  final bool trueFalseOption;

  const OptionContainerV2({
    super.key,
    required this.quizType,
    required this.showAnswerCorrectness,
    required this.showAudiencePoll,
    required this.hasSubmittedAnswerForCurrentQuestion,
    required this.constraints,
    required this.answerOption,
    required this.correctOptionId,
    required this.submitAnswer,
    required this.submittedAnswerId,
    this.audiencePollPercentage,
    this.trueFalseOption = false,
  });

  @override
  State<OptionContainerV2> createState() => _OptionContainerV2State();
}

class _OptionContainerV2State extends State<OptionContainerV2>
    with TickerProviderStateMixin {
  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
  );
  late Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
          parent: animationController, curve: Curves.easeInQuad));

  late AnimationController topContainerAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 180));
  late Animation<double> topContainerOpacityAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: topContainerAnimationController,
    curve: const Interval(0.0, 0.25, curve: Curves.easeInQuad),
  ));

  late Animation<double> topContainerAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: topContainerAnimationController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeInQuad)));

  late Animation<double> answerCorrectnessAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: topContainerAnimationController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeInQuad)));

  late double heightPercentage = 0.105;
  late AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  late TextSpan textSpan = TextSpan(
    text: widget.answerOption.title,
    style: GoogleFonts.nunito(
      textStyle: TextStyle(
        color: Colors.white, //Theme.of(context).colorScheme.background,
        height: 1.0,
        fontSize: 16.0,
      ),
    ),
  );

  @override
  void dispose() {
    animationController.dispose();
    topContainerAnimationController.dispose();
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  void playSound(String trackName) async {
    if (context.read<SettingsCubit>().getSettings().sound) {
      if (assetsAudioPlayer.isPlaying.value) {
        await assetsAudioPlayer.stop();
      }
      await assetsAudioPlayer.open(Audio(trackName));
      await assetsAudioPlayer.play();
    }
  }

  void playVibrate() async {
    if (context.read<SettingsCubit>().getSettings().vibration) {
      UiUtils.vibrate();
    }
  }

  int calculateMaxLines() {
    TextPainter textPainter =
        TextPainter(text: textSpan, textDirection: Directionality.of(context));

    textPainter.layout(maxWidth: widget.constraints.maxWidth * 0.85);

    return textPainter.computeLineMetrics().length;
  }

  Color _buildOptionBackgroundColor() {
    if (widget.showAnswerCorrectness) {
      return Theme.of(context).colorScheme.background;
    }
    if (widget.hasSubmittedAnswerForCurrentQuestion() &&
        widget.submittedAnswerId == widget.answerOption.id) {
      print("Submitted answer id is : ${widget.submittedAnswerId}");
      print("Stop here");

      return Theme.of(context).primaryColor;
    }

    return Theme.of(context).colorScheme.background;
  }

  void _onTapOptionContainerV2() {
    if (widget.showAnswerCorrectness) {
      //if user has submitted the answer then do not show correctness of the answer
      if (!widget.hasSubmittedAnswerForCurrentQuestion()) {
        widget.submitAnswer(widget.answerOption.id);

        topContainerAnimationController.forward();

        if (widget.correctOptionId == widget.answerOption.id) {
          playSound(correctAnswerSoundTrack);
        } else {
          playSound(wrongAnswerSoundTrack);
        }
        playVibrate();
      }
    } else {
      widget.submitAnswer(widget.answerOption.id);

      playSound(clickEventSoundTrack);
      playVibrate();
    }
  }

  Widget _buildOptionDetails(double optionWidth) {
    int maxLines = calculateMaxLines();
    if (!widget.hasSubmittedAnswerForCurrentQuestion()) {
      heightPercentage = maxLines > 2
          ? (heightPercentage + (0.03 * (maxLines - 2)))
          : heightPercentage;
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (_, child) {
        return Transform.scale(
          scale: animation.drive(Tween<double>(begin: 1.0, end: 0.9)).value,
          child: child,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: widget.constraints.maxHeight * (0.04)),
        height: widget.quizType == QuizTypes.groupPlay
            ? widget.constraints.maxHeight * (heightPercentage * 0.8)
            : widget.constraints.maxHeight *
                (heightPercentage *
                    0.67), // : widget.constraints.maxHeight * (heightPercentage * 0.6),
        width: optionWidth,
        alignment: Alignment.topCenter,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: maxLines > 2 ? 1 : 4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: _buildOptionBackgroundColor(),
                border: Border.all(color: Colors.white, width: 2),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    lightBlueColor.withOpacity(0.8),
                    lightBlueColor.withOpacity(0.75),
                    darkBlueColor.withOpacity(0.7),
                    darkBlueColor.withOpacity(0.8),
                    darkBlueColor,
                    darkBlueColor,
                    darkBlueColor.withOpacity(0.8),
                    darkBlueColor.withOpacity(0.7),
                    lightBlueColor.withOpacity(0.75),
                    lightBlueColor.withOpacity(0.8),
                  ],
                ),
              ),
              // alignment: Alignment.centerLeft,
              alignment: AlignmentDirectional.centerStart,
              child:
                  //if question type is 1 means render latex question
                  widget.quizType == QuizTypes.mathMania
                      ? Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: TeXView(
                            child: TeXViewInkWell(
                              rippleEffect: false,
                              onTap: (_) => _onTapOptionContainerV2(),
                              child: TeXViewDocument(
                                widget.answerOption.title!,
                                style: TeXViewStyle(
                                  contentColor: Colors.white,
                                  // textAlign: TeXViewTextAlign.center  ,
                                  fontStyle: TeXViewFontStyle(
                                    fontSize: 16,
                                    fontWeight: TeXViewFontWeight.bold,
                                  ),
                                ),
                              ),
                              id: widget.answerOption.id!,
                            ),
                            style: TeXViewStyle(
                              contentColor:
                                  Theme.of(context).colorScheme.onTertiary,
                              backgroundColor: Colors.transparent,
                              sizeUnit: TeXViewSizeUnit.pixels,
                              textAlign: TeXViewTextAlign.center,
                              fontStyle: TeXViewFontStyle(
                                fontSize: 21,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: RichText(
                            // text: textSpan,
                            // widget.hasSubmittedAnswerForCurrentQuestion()
                            text: TextSpan(
                              text: widget.answerOption.title,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  color: Colors
                                      .white, //Theme.of(context).colorScheme.background,
                                  height: 1.0,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
            ),
            if (widget.showAnswerCorrectness) ...[
              IgnorePointer(
                ignoring: true,
                child: AnimatedBuilder(
                  builder: (context, child) {
                    final height = topContainerAnimation
                        .drive(
                            Tween<double>(begin: 0.085, end: heightPercentage))
                        .value;
                    final width = topContainerAnimation
                        .drive(Tween<double>(begin: 0.2, end: 1.0))
                        .value;

                    final borderRadius = topContainerAnimation
                        .drive(Tween<double>(begin: 40.0, end: 10))
                        .value;

                    return Opacity(
                      opacity: topContainerOpacityAnimation.value,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: yellowColor.withOpacity(
                              0.8), //Theme.of(context).primaryColor,
                          // gradient: LinearGradient(
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          //   colors: [

                          //   yellowColor,
                          //   yellowColor.withOpacity(0.7),
                          //   yellowColor.withOpacity(0.5),
                          //   yellowColor.withOpacity(0.3),
                          //   yellowColor.withOpacity(0.3),
                          //   yellowColor.withOpacity(0.5),
                          //   yellowColor.withOpacity(0.7),
                          //   yellowColor,

                          // ]),
                          border: Border.all(color: Colors.white),
                          // borderRadius: BorderRadius.circular(borderRadius),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        width: optionWidth * width,
                        height: widget.constraints.maxHeight * height,
                        child: Transform.scale(
                          scale: answerCorrectnessAnimation.value,
                          child: Opacity(
                            opacity: answerCorrectnessAnimation.value,
                            child: Icon(
                              widget.answerOption.id == widget.correctOptionId
                                  ? Icons.check
                                  : Icons.close,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  animation: topContainerAnimationController,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    textSpan = TextSpan(
      text: widget.answerOption.title,
      style: GoogleFonts.nunito(
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onTertiary,
          height: 1.0,
          fontSize: 16.0,
        ),
      ),
    );
    return GestureDetector(
      onTapCancel: animationController.reverse,
      onTap: () async {
        animationController.reverse();
        _onTapOptionContainerV2();
      },
      onTapDown: (_) => animationController.forward(),
      child: widget.showAudiencePoll
          ? Row(
              children: [
                _buildOptionDetails(widget.constraints.maxWidth * .8),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "${widget.audiencePollPercentage}%",
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        color: Colors
                            .white, //Theme.of(context).colorScheme.onTertiary,
                        fontSize: 16.0,
                        fontWeight: FontWeights.medium,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : _buildOptionDetails(widget.constraints.maxWidth),
    );
  }
}
