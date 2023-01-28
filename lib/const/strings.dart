// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

class AppConstant {
  static const String NAME = 'name';
  static const String UID = 'uid';
  static const String EMAIL = 'email';
  static const String PHOTOURL = 'photoUrl';
  static const String FCMTOKEN = 'fcmToken';
  static const String DAY_SCHEDULE = 'daySchedule';
  static const String USER_COLLECTION = 'users';
  static const String HABIT_COLLECTION = 'habits';

  static const List<String> presetValuesStrings = [
    'Miscellanous',
    'Waking up',
    'College/Work',
    'Study',
    'Relax',
    'Gym/Workout',
    'Bedtime',
  ];
  Map<String, Color> presetColor = {
    AppConstant.presetValuesStrings[0]: Colors.blueGrey,
    AppConstant.presetValuesStrings[1]: Colors.lightBlueAccent,
    AppConstant.presetValuesStrings[2]: Colors.amber,
    AppConstant.presetValuesStrings[3]: Colors.greenAccent,
    AppConstant.presetValuesStrings[4]: Colors.redAccent,
    AppConstant.presetValuesStrings[5]: Colors.deepPurple,
    AppConstant.presetValuesStrings[6]: Colors.lightBlueAccent,
  };
}
