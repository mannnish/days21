import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultDivider extends StatelessWidget {
  final double leftPadding;
  const DefaultDivider({Key? key, this.leftPadding = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: const Divider(
        height: 0,
        color: CupertinoColors.systemGrey,
        thickness: 0.3,
      ),
    );
  }
}
