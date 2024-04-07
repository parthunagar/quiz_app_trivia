import 'package:flutter/material.dart';
import 'package:flutterquiz/ui/styles/colors.dart';
import 'package:flutterquiz/ui/widgets/customBackButton.dart';
import 'package:flutterquiz/utils/constants/fonts.dart';
import 'package:flutterquiz/utils/ui_utils.dart';
import 'package:google_fonts/google_fonts.dart';

class QAppBarQuiz extends StatelessWidget implements PreferredSizeWidget {
  const QAppBarQuiz({
    super.key,
    required this.title,
    this.roundedAppBar = true,
    this.removeSnackBars = true,
    this.bottom,
    this.bottomHeight = 52,
    this.usePrimaryColor = false,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.onTapBackButton,
    this.elevation,
  });

  final Widget title;
  final double? elevation;
  final TabBar? bottom;
  final bool automaticallyImplyLeading;
  final Function()? onTapBackButton;
  final List<Widget>? actions;
  final bool roundedAppBar;
  final double bottomHeight;
  final bool removeSnackBars;
  final bool usePrimaryColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      // toolbarHeight: Scaffold.of(context).appBarMaxHeight! * 7,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation ?? (roundedAppBar ? 2 : 0),
      centerTitle: true,
      shadowColor: Theme.of(context).colorScheme.background.withOpacity(0.4),
      // foregroundColor: usePrimaryColor
      //     ? Theme.of(context).primaryColor
      //     : Theme.of(context).colorScheme.onTertiary,
      // backgroundColor: roundedAppBar
      //     ? Theme.of(context).colorScheme.background
      //     : Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: const Color(0xFF1e1891),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      leading: automaticallyImplyLeading
          ? QBackButton(
              onTap: onTapBackButton,
              removeSnackBars: removeSnackBars,
              color: usePrimaryColor ? Theme.of(context).primaryColor : null,
            )
          : GestureDetector(
              onTap: onTapBackButton,
              child: Container(
                // margin: EdgeInsets.only(top: 2),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 2,bottom: 2,right: 2),
                  decoration:  BoxDecoration(
                    // color: Theme.of(context).scaffoldBackgroundColor,
                    gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            lightBlueColor.withOpacity(0.8),
                            lightBlueColor.withOpacity(0.75),
                            darkBlueColor.withOpacity(0.7),
                            darkBlueColor.withOpacity(0.8),
                            darkBlueColor.withOpacity(0.9),
                            darkBlueColor,
                            darkBlueColor,
                            darkBlueColor,
                            darkBlueColor,
                            darkBlueColor,
                            darkBlueColor.withOpacity(0.9),
                            darkBlueColor.withOpacity(0.8),
                            darkBlueColor.withOpacity(0.7),
                            lightBlueColor.withOpacity(0.75),
                            lightBlueColor.withOpacity(0.8),
                          ],
                        ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color:
                          usePrimaryColor ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                ),
              ),
            ),
      titleTextStyle: GoogleFonts.nunito(
        textStyle: TextStyle(
          color: usePrimaryColor
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.onTertiary,
          fontWeight: FontWeights.bold,
          fontSize: 18.0,
        ),
      ),
      title: title,
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width * UiUtils.hzMarginPct,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context)
                      .colorScheme
                      .onTertiary
                      .withOpacity(0.08),
                ),
                child: bottom,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => bottom == null
      ? const Size.fromHeight(kToolbarHeight)
      : Size.fromHeight(kToolbarHeight + bottomHeight);
}
