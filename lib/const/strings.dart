// ignore_for_file: constant_identifier_names
import 'package:flutter/cupertino.dart';
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
    'Walking',
  ];
  static Map<String, IconData> presetIcons = {
    AppConstant.presetValuesStrings[0]: CupertinoIcons.rectangle_stack_badge_person_crop,
    AppConstant.presetValuesStrings[1]: CupertinoIcons.sunrise_fill,
    AppConstant.presetValuesStrings[2]: CupertinoIcons.building_2_fill,
    AppConstant.presetValuesStrings[3]: CupertinoIcons.book,
    AppConstant.presetValuesStrings[4]: CupertinoIcons.bed_double_fill,
    AppConstant.presetValuesStrings[5]: CupertinoIcons.person_2_fill,
    AppConstant.presetValuesStrings[6]: CupertinoIcons.bed_double_fill,
    AppConstant.presetValuesStrings[7]: Icons.directions_walk,
  };
}
