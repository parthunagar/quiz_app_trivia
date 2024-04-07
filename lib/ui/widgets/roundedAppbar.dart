import 'package:flutter/material.dart';
import 'package:flutterquiz/ui/widgets/customBackButton.dart';
import 'package:flutterquiz/utils/ui_utils.dart';

class RoundedAppbar extends StatelessWidget {
  final String title;
  final Widget? trailingWidget;
  final bool? removeSnackBars;
  final Color? appBarColor;
  final Color? appTextAndIconColor;

  const RoundedAppbar(
      {super.key,
      required this.title,
      this.trailingWidget,
      this.removeSnackBars,
      this.appBarColor,
      this.appTextAndIconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 25.0),
      height:
          MediaQuery.of(context).size.height * UiUtils.appBarHeightPercentage,
      decoration: BoxDecoration(
          boxShadow: UiUtils.kAppbarBoxShadow,
          color: appBarColor ?? Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0))),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 25.0),
              child: CustomBackButton(
                removeSnackBars: removeSnackBars,
                iconColor:
                    appTextAndIconColor ?? Theme.of(context).primaryColor,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22.0,
                  color: appTextAndIconColor ?? Theme.of(context).primaryColor),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: trailingWidget ?? Container(),
          ),
        ],
      ),
    );
  }
}
