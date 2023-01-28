import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:days21/const/appcolors.dart';
import 'package:days21/const/divider.dart';
import 'package:days21/models/habit.model.dart';
import 'package:days21/models/user.model.dart';
import 'package:days21/repositories/fit.repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../const/appconfig.dart';

class WalkingHabit extends StatefulWidget {
  final String selectedHabitId;
  final int taget;
  const WalkingHabit({Key? key, required this.taget, required this.selectedHabitId}) : super(key: key);

  @override
  State<WalkingHabit> createState() => _WalkingHabitState();
}

class _WalkingHabitState extends State<WalkingHabit> {
  int steps = 0;
  static const Color systemPurple = Colors.indigo;
  double horizontalPadding = 15.0;
  double verticalPadding = 15.0;
  EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 15, vertical: 15);
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15);
  double radius = 10.0;
  BoxDecoration decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: AppColors.DarkGrayBorder, width: 0.3),
  );
  late DocumentReference habitReference;

  @override
  initState() {
    super.initState();
    fetchSteps();
  }

  void fetchSteps() async {
    steps = await FitRepo.getSteps();
    setState(() {});
  }

  InkWell backButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: const Icon(Icons.arrow_back, color: AppColors.DarkGrayBorder, size: 30),
      ),
    );
  }

  Widget headerStyle(String headerText, HabitModel habit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        children: [
          backButton(),
          Text(
            headerText,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (ctx) => CupertinoAlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('This will delete the habit.'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.DarkGrayBorder),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                    CupertinoDialogAction(
                      child: const Text('Delete', style: TextStyle(color: AppColors.Red)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        habitReference.delete();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
            child: iconTemplate(color: AppColors.Red, icon: Icons.delete),
          )
        ],
      ),
    );
  }

  Container iconTemplate({Color color = AppColors.DarkGrayBorder, IconData icon = Icons.minimize_outlined}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(5),
      //   border: Border.all(color: color, width: 0.3),
      // ),
      child: Icon(
        icon,
        color: color,
        size: 23,
      ),
    );
  }

  CircularPercentIndicator percentageWidget(BuildContext context) {
    return CircularPercentIndicator(
      radius: MediaQuery.of(context).size.width * 0.17,
      lineWidth: 17,
      backgroundColor: CupertinoColors.systemGrey,
      animation: true,
      startAngle: 0.0,
      animationDuration: Duration.millisecondsPerSecond,
      percent: min(1.0, steps / widget.taget),
      progressColor: systemPurple,
      center: FittedBox(
        child: Text(
          (steps * 100 / widget.taget as double).toStringAsFixed(1) + "%",
          style: const TextStyle(
            color: systemPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    habitReference = FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel.uid)
        .collection('habits')
        .doc(widget.selectedHabitId);
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: habitReference.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final ds = snapshot.data as DocumentSnapshot;
            HabitModel habit = HabitModel.fromJson(ds.data() as Map<String, dynamic>);
            List intervalInfo = habit.intervalInfo;

            return Column(
              children: [
                headerStyle(habit.title, habit),
                const DefaultDivider(),
                const SizedBox(height: 50),
                percentageWidget(context),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$steps Steps Walked\n out of ${widget.taget}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: systemPurple,
                      ),
                    ),
                    // const SizedBox(width: 6),
                    // const Icon(Icons.directions_walk, color: Colors.black, size: 20),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  margin: margin,
                  padding: padding,
                  decoration: decoration,
                  child: TableCalendar(
                    onFormatChanged: (format) => {},
                    onDaySelected: (date, events) {
                      DateTime now = DateTime.now();
                      if (now.day == date.day && now.month == date.month && now.year == date.year) {
                        return;
                      }
                      if (habit.isInRange(date)) {
                        habit.removeInterval(date);
                      } else {
                        habit.addDate(date);
                      }
                      habitReference.update(habit.toJson());
                    },
                    selectedDayPredicate: (DateTime randomDate) {
                      return habit.isInRange(randomDate);
                    },
                    firstDay: AppConfig.firstDate,
                    focusedDay: DateTime.now(),
                    lastDay: DateTime.now(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: margin.left),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: padding,
                          decoration: decoration,
                          child: Row(
                            children: [
                              const Text(
                                'Max Streak',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(width: 5),
                              const Icon(CupertinoIcons.flame_fill, color: AppColors.Red, size: 21),
                              const SizedBox(width: 5),
                              Text(
                                intervalInfo[3].toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: padding,
                          decoration: decoration,
                          child: Row(
                            children: [
                              const Text(
                                'Total Days',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(width: 5),
                              const Icon(CupertinoIcons.calendar, color: AppColors.Orange, size: 21),
                              const SizedBox(width: 5),
                              Text(
                                intervalInfo[0].toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
