import 'package:flutter/material.dart';

class DefaultAppBar {
  static PreferredSizeWidget centerBack(context, title) {
    return AppBar(
      backgroundColor: Colors.indigo,
      title: Text(title),
      centerTitle: true,
      // automaticallyImplyLeading: true,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }

  static PreferredSizeWidget center(title) {
    return AppBar(
      backgroundColor: Colors.indigo,
      title: Text(title),
      centerTitle: true,
    );
  }
}
