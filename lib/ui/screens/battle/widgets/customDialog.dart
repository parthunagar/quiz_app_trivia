import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterquiz/utils/ui_utils.dart';

class CustomDialog extends StatelessWidget {
  final double? height; //in multiplication of device height
  final Widget child;
  final Function? onBackButtonPress;
  final Function? onWillPop;
  final double? topPadding;

  const CustomDialog(
      {super.key,
      this.height,
      required this.child,
      this.topPadding,
      this.onBackButtonPress,
      this.onWillPop});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop == null
          ? () {
              return Future.value(true);
            }
          : onWillPop as Future<bool> Function()?,
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: UiUtils.dialogBlurSigma, sigmaY: UiUtils.dialogBlurSigma),
        child: Material(
          type: MaterialType.transparency,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * (0.075),
                      top: 20.0,
                    ),
                    child: IconButton(
                        onPressed: onBackButtonPress == null
                            ? () {
                                Navigator.of(context).pop();
                              }
                            : onBackButtonPress as void Function()?,
                        iconSize: 40.0,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.background,
                        ))),
                SizedBox(
                  height:
                      topPadding ?? MediaQuery.of(context).size.height * (0.02),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(UiUtils.dialogRadius)),
                    height: height ??
                        MediaQuery.of(context).size.height *
                            UiUtils.dialogHeightPercentage,
                    width: MediaQuery.of(context).size.width *
                        UiUtils.dialogWidthPercentage,
                    child: child,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
