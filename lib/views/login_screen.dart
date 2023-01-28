// ignore_for_file: avoid_print
import 'package:days21/repositories/auth.repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future<bool>.value(false),
      child: Scaffold(
        body: Center(
          child: InkWell(
            onTap: () async {
              try {
                await AuthRepo.signIn(context);
              } catch (e) {
                print(e);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CupertinoColors.systemPurple,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Image(
                    image: AssetImage('assets/google.png'),
                    height: 30,
                    width: 30,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Login with Google',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
