import 'package:days21/const/app_bar.dart';
import 'package:days21/repositories/auth.repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: DefaultAppBar.center('Home Screen'),
        floatingActionButton: FloatingActionButton(
          onPressed: () async => await AuthRepo.signOut(context),
          backgroundColor: CupertinoColors.systemIndigo,
          child: const Icon(Icons.logout, size: 27),
        ),
      ),
    );
  }
}
