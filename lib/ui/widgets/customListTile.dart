import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget leadingChild;
  final String? title;
  final String? subtitle;
  final Function? trailingButtonOnTap;
  final double opacity;

  const CustomListTile(
      {super.key,
      required this.leadingChild,
      required this.subtitle,
      required this.title,
      required this.trailingButtonOnTap,
      required this.opacity});

  Widget _buildVerticalLine(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color: Theme.of(context).primaryColor,
      width: 5.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              color: Theme.of(context)
                  .primaryColor
                  .withOpacity(0.5), //confirm shadow color
            )
          ],
          borderRadius: BorderRadius.circular(5.0)),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      width: MediaQuery.of(context).size.width * (0.85),
      height: MediaQuery.of(context).size.height * (0.14),
      child: Opacity(
        opacity: opacity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildVerticalLine(context),
                const SizedBox(
                  width: 7.5,
                ),
                CircleAvatar(
                  radius: 15.5,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: leadingChild,
                ),
                const SizedBox(
                  width: 7.5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (0.535),
                      child: Text(
                        "$title",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.secondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (0.55),
                      child: Text(
                        "$subtitle",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //when data comes from notification close button not show
            const Spacer(),
            trailingButtonOnTap != null
                ? InkWell(
                    onTap: trailingButtonOnTap as void Function()?,
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                : Container(),
            const SizedBox(
              width: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
