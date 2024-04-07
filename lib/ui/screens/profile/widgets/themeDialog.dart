import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterquiz/ui/styles/theme/themeCubit.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeCubit, ThemeState>(
      bloc: context.read<ThemeCubit>(),
      listener: (context, state) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
          builder: (_) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              height: MediaQuery.of(context).size.height * 0.5,
            );
          },
        );
      },
      builder: (context, state) {
        return const SizedBox();
        // return AlertDialog(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        //   ),
        //   content: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: appThemeData.keys.map((theme) {
        //       return Container(
        //         margin: EdgeInsets.symmetric(vertical: 10.0),
        //         decoration: BoxDecoration(
        //           color: state.appTheme == theme
        //               ? Theme.of(context).primaryColor
        //               : Theme.of(context).colorScheme.secondary,
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         child: ListTile(
        //           trailing: state.appTheme == theme
        //               ? Icon(
        //                   Icons.check,
        //                   color: Theme.of(context).backgroundColor,
        //                 )
        //               : SizedBox(),
        //           onTap: () {
        //             context.read<ThemeCubit>().changeTheme(theme);
        //           },
        //           title: Text(
        //             AppLocalization.of(context)!.getTranslatedValues(
        //                 UiUtils.getThemeLabelFromAppTheme(theme))!,
        //             style: TextStyle(
        //               color: Theme.of(context).backgroundColor,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //       );
        //     }).toList(),
        //   ),
        // );
      },
    );
  }
}
