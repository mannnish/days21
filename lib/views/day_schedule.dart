// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:days21/const/app_bar.dart';
import 'package:days21/const/strings.dart';
import 'package:days21/models/preset.model.dart';
import 'package:days21/models/user.model.dart';
import 'package:days21/views/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySchedule extends StatefulWidget {
  const DaySchedule({Key? key}) : super(key: key);

  @override
  State<DaySchedule> createState() => _DayScheduleState();
}

class _DayScheduleState extends State<DaySchedule> {
  static const double iconSize = 30.0;
  List<PresetModel> userPresets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Day Schedule'),
        centerTitle: true,
        actions: [
          if (userPresets.isNotEmpty)
            InkWell(
              onTap: () async {
                await saveFn();
              },
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          backgroundColor: Colors.indigo,
          onPressed: addFn,
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // for (int i = 0; i < userPresets.length; ++i) presetBox(i),
              // addBtn(),
              // container(Colors.indigo),
              for (int i = 0; i < userPresets.length; ++i) presetBox(i),
              if (userPresets.isEmpty) const Center(child: Text('Please enter some routine'))
              // InkWell(
              //   onTap: ,
              //   child: container(Colors.grey),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future saveFn() async {
    List jsonData = userPresets.map((e) => e.toJson()).toList();
    print(jsonData);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection(AppConstant.USER_COLLECTION)
        .doc(UserModel.uid)
        .update({AppConstant.DAY_SCHEDULE: jsonData});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void addFn() async {
    DateTime now = DateTime.now();
    DateTime initial = DateTime.now();
    if (userPresets.isEmpty) {
      initial = DateTime(now.year, now.month, now.day, 7, 0);
    } else {
      initial = userPresets.last.endTime;
    }
    DateTime endTime = initial;
    await showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 270,
        child: CupertinoDatePicker(
          initialDateTime: initial,
          minuteInterval: 15,
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (date) {
            endTime = date;
          },
        ),
      ),
    );
    PresetModel presetModel = PresetModel(
      presetValue: AppConstant.presetValuesStrings[0],
      startTime: DateTime(now.year, now.month, now.day, 0, 0),
      endTime: endTime,
    );
    if (userPresets.isNotEmpty) {
      presetModel.startTime = userPresets.last.endTime;
    }
    if (userPresets.isEmpty || (userPresets.isNotEmpty && presetModel.endTime.isAfter(presetModel.startTime))) {
      setState(() {
        userPresets.add(presetModel);
      });
    }
  }

  String dateTimeToStr(DateTime dt) {
    String str = DateFormat('hh:mm a').format(dt);
    return str;
  }

  Widget presetBox(int i) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.lightBlueAccent[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            isDense: false,
            isExpanded: true,
            underline: const SizedBox(),
            items: AppConstant.presetValuesStrings.map((String e) {
              return DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }).toList(),
            value: userPresets[i].presetValue,
            onChanged: (val) {
              if (val == null) return;
              setState(() {
                userPresets[i].presetValue = val;
              });
            },
          ),
          const SizedBox(height: 4),
          Text(
            dateTimeToStr(userPresets[i].startTime) + " to " + dateTimeToStr(userPresets[i].endTime),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Container presetContainer(int i) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 14),
  //     width: double.infinity,
  //     height: 100,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       // gradient: LinearGradient(
  //       //   begin: Alignment.topRight,
  //       //   end: Alignment.bottomLeft,
  //       //   colors: [Colors.lightBlue, Colors.lightBlueAccent.withOpacity(0.4)],
  //       // ),
  //       color: Colors.amber[100],
  //     ),
  //     alignment: Alignment.centerRight,
  //     // ignore: prefer_const_constructors
  //     child: Padding(
  //       padding: const EdgeInsets.only(right: 40),
  //       // child: const Text(
  //       //   '+ Add',
  //       //   style: TextStyle(
  //       //     fontWeight: FontWeight.bold,
  //       //     color: Colors.white,
  //       //     fontSize: 26,
  //       //   ),
  //       // ),
  //       child: DropdownButton<String>(
  //         items: AppConstant.presetValuesStrings.map((String e) {
  //           return DropdownMenuItem(
  //             value: e,
  //             child: Text(
  //               e,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //                 fontSize: 18,
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         value: userPresets[i].presetValue,
  //         onChanged: (val) {
  //           if (val == null) return;
  //           setState(() {
  //             userPresets[i].presetValue = val;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Container container(Color color) {
  //   return Container(
  //     width: double.infinity,
  //     height: 100,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       gradient: LinearGradient(
  //         begin: Alignment.topRight,
  //         end: Alignment.bottomLeft,
  //         colors: [color, color.withOpacity(0.4)],
  //       ),
  //     ),
  //     alignment: Alignment.centerRight,
  //     // ignore: prefer_const_constructors
  //     child: Padding(
  //       padding: const EdgeInsets.only(right: 40),
  //       child: const Text(
  //         '+ Add',
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //           fontSize: 26,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget addBtn() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       if (userPresets.isNotEmpty)
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               userPresets.removeLast();
  //             });
  //           },
  //           child: const Icon(
  //             Icons.remove,
  //             size: iconSize,
  //           ),
  //         ),
  //       if (userPresets.isNotEmpty) const SizedBox(width: 20),
  //       InkWell(
  //         onTap: () {
  //           // open picker
  //           // take time from user and it must be greater than last userPreset
  //           String presetValue = AppConstant.presetValuesStrings[0];
  //           DateTime now = DateTime.now();
  //           DateTime endTime = DateTime.now();
  //           if (userPresets.isNotEmpty) endTime = userPresets.last.endTime;
  //           showDialog(
  //             context: context,
  //             barrierDismissible: false,
  //             builder: (ctx) => StatefulBuilder(
  //               builder: (ctx, setStateDialog) {
  //                 return AlertDialog(
  //                   title: const Text('Add Preset'),
  //                   content: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
  //                           const Spacer(),
  //                           DropdownButton<String>(
  //                             value: presetValue,
  //                             items: AppConstant.presetValuesStrings.map((String e) {
  //                               return DropdownMenuItem(child: Text(e), value: e);
  //                             }).toList(),
  //                             onChanged: (val) {
  //                               if (val != null) {
  //                                 setStateDialog(() => presetValue = val);
  //                               }
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 10),
  //                       InkWell(
  //                         onTap: () async {
  //                           TimeOfDay? temp = await showTimePicker(
  //                             context: context,
  //                             initialTime: TimeOfDay(hour: endTime.hour, minute: endTime.minute),
  //                           );
  //                           if (temp == null) return;
  //                           endTime = DateTime(now.year, now.month, now.day, temp.hour, temp.minute);
  //                           setStateDialog(() {});
  //                         },
  //                         child: Row(
  //                           children: [
  //                             const Text('End Time', style: TextStyle(fontWeight: FontWeight.bold)),
  //                             const Spacer(),
  //                             Text('${endTime.hour} : ${endTime.minute}', style: const TextStyle(fontSize: 12)),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   actions: [
  //                     InkWell(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: const Padding(
  //                         padding: EdgeInsets.only(bottom: 8.0),
  //                         child: Text(
  //                           'Discard',
  //                           style: TextStyle(color: CupertinoColors.systemGrey),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 20),
  //                     InkWell(
  //                       onTap: () {
  //                         if (presetValue == '' || !AppConstant.presetValuesStrings.contains(presetValue)) {
  //                           Navigator.pop(context);
  //                         }
  //                         PresetModel presetModel = PresetModel(
  //                           presetValue: presetValue,
  //                           startTime: DateTime(now.year, now.month, now.day),
  //                           endTime: endTime,
  //                         );
  //                         if (userPresets.isNotEmpty) {
  //                           presetModel.startTime = userPresets.last.endTime;
  //                         }
  //                         if (userPresets.isEmpty ||
  //                             (userPresets.isNotEmpty && presetModel.endTime.isAfter(presetModel.startTime))) {
  //                           setState(() {
  //                             userPresets.add(presetModel);
  //                           });
  //                         }
  //                         Navigator.pop(context);
  //                       },
  //                       child: const Padding(
  //                         padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
  //                         child: Text(
  //                           'Save',
  //                           style: TextStyle(color: CupertinoColors.activeBlue),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             ),
  //           );
  //         },
  //         child: const Icon(Icons.add, size: iconSize),
  //       ),
  //     ],
  //   );
  // }

}
