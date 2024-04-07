import 'package:flutter/material.dart';

class UserCrownContainer extends StatelessWidget {
  final String? crownType;
  const UserCrownContainer({super.key, this.crownType});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 28.0,
      width: 28.0,
    );
  }
}
