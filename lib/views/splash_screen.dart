import 'package:days21/const/strings.dart';
import 'package:days21/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    process();
  }

  void process() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString(AppConstant.UID) ?? 'errorId';
    if (uid == 'errorId') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      await UserModel.fromPrefs();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
