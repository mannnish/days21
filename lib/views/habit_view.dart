import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:days21/const/appcolors.dart';
import 'package:days21/const/appconfig.dart';
import 'package:days21/const/divider.dart';
import 'package:days21/models/habit.model.dart';
import 'package:days21/models/user.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitView extends StatefulWidget {
  final String selectedHabitId;
  const HabitView({Key? key, required this.selectedHabitId}) : super(key: key);

  @override
  State<HabitView> createState() => _HabitViewState();
}

class _HabitViewState extends State<HabitView> {
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
  // late List<int> intervalInfo;
  late DocumentReference habitReference;

  @override
  void initState() {
    super.initState();
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
          // InkWell(
          //   onTap: () async {
          //     String title = habit.title;
          //     List isBad = ['Yes', 'No'];
          //     List colors = [Colors.purple, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.red];
          //     Color selectedColor = colors[0];
          //     String selectedIsBad = 'No';
          //     const textStyle = TextStyle(fontSize: 13);

          //     await showCupertinoDialog(
          //       context: context,
          //       builder: (ctx) {
          //         return StatefulBuilder(
          //           builder: (context, setState) {
          //             return CupertinoAlertDialog(
          //               title: const Text('Edit Habit'),
          //               content: Material(
          //                 color: Colors.transparent,
          //                 child: Column(
          //                   children: [
          //                     const SizedBox(height: 15),
          //                     CupertinoTextField(
          //                         placeholder: title,
          //                         onChanged: (val) {
          //                           title = val;
          //                         }),
          //                     const SizedBox(height: 5),
          //                     Row(
          //                       children: [
          //                         const Text('Is Bad Habit?'),
          //                         const Spacer(),
          //                         DropdownButton(
          //                           underline: const SizedBox(),
          //                           value: selectedIsBad,
          //                           items: isBad.map((e) {
          //                             return DropdownMenuItem(child: Text(e, style: textStyle), value: e);
          //                           }).toList(),
          //                           onChanged: (val) {
          //                             setState(() {
          //                               selectedIsBad = val.toString();
          //                             });
          //                           },
          //                         ),
          //                       ],
          //                     ),
          //                     // drop down for color
          //                     Row(
          //                       children: [
          //                         const Text('Select Color'),
          //                         const Spacer(),
          //                         DropdownButton(
          //                           underline: const SizedBox(),
          //                           value: selectedColor,
          //                           items: colors.map((e) {
          //                             return DropdownMenuItem(
          //                               child: Container(color: e, width: 30, height: 30),
          //                               value: e,
          //                             );
          //                           }).toList(),
          //                           onChanged: (val) {
          //                             setState(() {
          //                               selectedColor = val as Color;
          //                             });
          //                           },
          //                         ),
          //                       ],
          //                     ),
          //                     const SizedBox(height: 5),
          //                   ],
          //                 ),
          //               ),
          //               actions: [
          //                 CupertinoDialogAction(
          //                   child: const Text('Cancel', style: TextStyle(color: AppColors.DarkGrayBorder)),
          //                   onPressed: () => Navigator.pop(context),
          //                 ),
          //                 CupertinoDialogAction(
          //                   child: const Text('Update'),
          //                   onPressed: () async {
          //                     title = title.trim();
          //                     if (title.isEmpty) {
          //                       return;
          //                     }
          //                     Navigator.pop(context);
          //                     await habitReference.update({
          //                       'title': title,
          //                       'isBad': selectedIsBad == 'Yes',
          //                       'color': selectedColor.value.toString(),
          //                     });
          //                   },
          //                 ),
          //               ],
          //             );
          //           },
          //         );
          //       },
          //     );
          //   },
          //   child: iconTemplate(color: AppColors.DarkGrayBorder, icon: Icons.edit),
          // ),
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

  InkWell backButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: const Icon(Icons.arrow_back, color: AppColors.DarkGrayBorder, size: 30),
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
        body: streamBuilder(),
      ),
    );
  }

  StreamBuilder<DocumentSnapshot<Object?>> streamBuilder() {
    return StreamBuilder(
        stream: habitReference.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final ds = snapshot.data as DocumentSnapshot;
          HabitModel habit = HabitModel.fromJson(ds.data() as Map<String, dynamic>);
          List intervalInfo = habit.intervalInfo;
          return SingleChildScrollView(
            child: Column(
              children: [
                headerStyle(habit.title, habit),
                const DefaultDivider(),
                Container(
                  margin: margin,
                  padding: padding,
                  decoration: decoration,
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.flame_fill, color: AppColors.Red, size: 35),
                      const SizedBox(width: 5),
                      Text(
                        habit.currentStreak.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.LightGray,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          habit.lastStreakDateFormatted,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.DarkGrayBorder,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
                const SizedBox(height: 15),
                // percentage indicator
                if (habit.isBoolean)
                  Row(
                    children: [
                      const Spacer(),
                      percentageWidget(context, intervalInfo),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: systemPurple,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(CupertinoIcons.check_mark_circled_solid, color: systemPurple, size: 20),
                            ],
                          ),
                          Row(
                            children: const [
                              Text(
                                'Missed',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: CupertinoColors.systemGrey,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                const SizedBox(height: 15),
                // StackedLineSeries(
                //   dataSource: dataSource,
                //   xValueMapper: xValueMapper,
                //   yValueMapper: yValueMapper,
                // ),
                Container(
                  margin: margin,
                  padding: padding,
                  decoration: decoration,
                  child: TableCalendar(
                    onFormatChanged: (format) => {},
                    onDaySelected: (date, events) {
                      // TODO : ADD AND REMOVE DATE
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
              ],
            ),
          );
        });
  }

  CircularPercentIndicator percentageWidget(BuildContext context, List<dynamic> intervalInfo) {
    return CircularPercentIndicator(
      radius: MediaQuery.of(context).size.width * 0.15,
      lineWidth: 15,
      backgroundColor: CupertinoColors.systemGrey,
      animation: true,
      startAngle: 0.0,
      animationDuration: Duration.millisecondsPerSecond,
      percent: intervalInfo[1] / intervalInfo[0],
      progressColor: systemPurple,
      center: FittedBox(
        child: Text(
          (intervalInfo[1] * 100 / intervalInfo[0] as double).toStringAsFixed(1) + "%",
          style: const TextStyle(
            color: systemPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
