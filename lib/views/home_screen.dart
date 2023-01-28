import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:days21/const/app_bar.dart';
import 'package:days21/const/divider.dart';
import 'package:days21/const/strings.dart';
import 'package:days21/models/habit.model.dart';
import 'package:days21/models/user.model.dart';
import 'package:days21/repositories/auth.repo.dart';
import 'package:days21/views/add_habit.dart';
import 'package:days21/views/walking_habit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'habit_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CollectionReference userHabitCollection;
  double horizontalPadding = 15.0;
  double verticalPadding = 15.0;
  // String hoveredHabitId = '';
  String selectedHabitId = '';
  Color unselectedBgColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    userHabitCollection =
        FirebaseFirestore.instance.collection(AppConstant.USER_COLLECTION).doc(UserModel.uid).collection('habits');
  }

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
        body: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHabit()));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // color: Colors.lightBlue,
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 40),
                    const SizedBox(width: 15),
                    // Text(
                    //   'Add Habit',
                    //   style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    // ),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Add Habit',
                          textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TypewriterAnimatedText(
                          "Set habit of 'Read 20 Pages Daily'",
                          textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TypewriterAnimatedText(
                          "You can quit your bad habit",
                          textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                      totalRepeatCount: 4,
                      pause: const Duration(milliseconds: 1000),
                      // displayFullTextOnTap: true,
                      // stopPauseOnTap: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: userHabitCollection.snapshots(),
                builder: (ctx, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length == 0) {
                      return const Center(
                        child: Text('User found, but no habits'),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        HabitModel habit = HabitModel.fromJson(ds.data() as Map<String, dynamic>);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: singleHabit(habit, ds.id),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No snapshot data'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget singleHabit(HabitModel habit, String docId) {
    var column = Column(
      children: [
        SizedBox(height: verticalPadding),
        Row(
          children: [
            Icon(
              AppConstant.presetIcons[habit.presetValue],
              color: CupertinoColors.systemGrey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "You can do this habit",
                  style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                ),
              ],
            ),
            const Spacer(),
            if (habit.currentStreak != 0)
              Text(
                habit.currentStreak.toString(),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            if (habit.currentStreak != 0)
              const Icon(
                CupertinoIcons.flame_fill,
                color: CupertinoColors.systemRed,
                size: 18,
              ),
            const SizedBox(width: 13),
            if (!habit.doneForToday())
              // ?
              InkWell(
                onTap: () {
                  habit.addDate(DateTime.now());
                  userHabitCollection.doc(docId).update(habit.toJson());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black87, width: 0.5),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.check, color: Colors.black87, size: 16),
                      Text(
                        ' Done ',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
        SizedBox(height: verticalPadding),
        DefaultDivider(leftPadding: horizontalPadding),
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      color: unselectedBgColor,
      child: InkWell(
        onTap: () async {
          if (habit.title.toLowerCase().contains('steps') || habit.title.toLowerCase().contains('walk')) {
            String newstr = habit.title.replaceAll(RegExp(r'[^0-9]'), '');
            int? stepsTarget = int.tryParse(newstr);
            if (stepsTarget != null && stepsTarget != 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WalkingHabit(taget: stepsTarget, selectedHabitId: docId)),
              );
              return;
            }
          }
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HabitView(selectedHabitId: docId)),
          );
        },
        child: column,
      ),
    );
  }
}
