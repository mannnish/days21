// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:days21/const/strings.dart';
import 'package:days21/models/user.model.dart';
import 'package:days21/views/day_schedule.dart';
import 'package:days21/views/home_screen.dart';
import 'package:days21/views/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsignin;

class AuthRepo {
  static signIn(context) async {
    try {
      final googleSignIn = gsignin.GoogleSignIn(scopes: <String>['email']);
      final gsignin.GoogleSignInAccount? gsiAccountUser = await googleSignIn.signIn();
      if (gsiAccountUser == null) throw ("gsiAccountUser is null");

      final gsignin.GoogleSignInAuthentication ga = await gsiAccountUser.authentication;
      var cred = GoogleAuthProvider.credential(accessToken: ga.accessToken, idToken: ga.idToken);
      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(cred);
      final User? user = authResult.user;
      if (user == null) return null;
      UserModel.name = user.displayName!;
      UserModel.uid = user.uid;
      UserModel.email = user.email!;
      UserModel.photoUrl = user.photoURL!;
      UserModel.fcmToken = (await generateFcm())!;
      await UserModel.toPrefs();

      if (!await isRegistered(UserModel.uid)) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        firestore.collection(AppConstant.USER_COLLECTION).doc(UserModel.uid).set(UserModel.toJson());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DaySchedule()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      throw ("error static Future<gsignin.GoogleSignInAccount?> signIn() : $e");
    }
  }

  static Future<void> signOut(context) async {
    await UserModel.reset();
    try {
      await FirebaseAuth.instance.signOut();
      await gsignin.GoogleSignIn().signOut();
    } catch (e) {
      print("error static Future<void> signOut() : $e");
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
  }

  static Future<bool> isRegistered(String uid) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      return firestore.collection(AppConstant.USER_COLLECTION).doc(uid).get().then((value) => value.exists);
    } catch (e) {
      throw ("error Future<bool> isRegistered(String uid) : $e");
    }
  }

  static Future<String?> generateFcm() async {
    var _messaging = FirebaseMessaging.instance;
    await _messaging.requestPermission(alert: true, badge: true, provisional: false, sound: true);
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }
}
