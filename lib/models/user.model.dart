import 'package:days21/const/appconfig.dart';
import 'package:days21/const/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  static String name = 'name';
  static String uid = 'errorId';
  static String email = 'email';
  static String photoUrl = AppConfig.tempdp;
  static String fcmToken = '';

  static fromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString(AppConstant.NAME) ?? 'name';
    uid = prefs.getString(AppConstant.UID) ?? 'errorId';
    email = prefs.getString(AppConstant.EMAIL) ?? 'email';
    photoUrl = prefs.getString(AppConstant.PHOTOURL) ?? AppConfig.tempdp;
    fcmToken = prefs.getString(AppConstant.FCMTOKEN) ?? '';
  }

  static Future toPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstant.NAME, name);
    prefs.setString(AppConstant.UID, uid);
    prefs.setString(AppConstant.EMAIL, email);
    prefs.setString(AppConstant.PHOTOURL, photoUrl);
    prefs.setString(AppConstant.FCMTOKEN, fcmToken);
  }

  static toJson() {
    return {
      AppConstant.NAME: name,
      AppConstant.UID: uid,
      AppConstant.EMAIL: email,
      AppConstant.PHOTOURL: photoUrl,
      AppConstant.FCMTOKEN: fcmToken,
    };
  }

  static Future<void> reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    name = 'name';
    uid = 'errorId';
    email = 'email';
    fcmToken = '';
    photoUrl = AppConfig.tempdp;
  }
}
