import 'package:flutter/material.dart';

class DefaultAppBar {
  static PreferredSizeWidget center(title) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }
}
