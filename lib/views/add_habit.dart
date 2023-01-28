import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:days21/const/app_bar.dart';
import 'package:days21/const/strings.dart';
import 'package:days21/models/habit.model.dart';
import 'package:days21/models/user.model.dart';
import 'package:flutter/material.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({Key? key}) : super(key: key);

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  String title = '';
  String units = '';
  // bool isBoolean = true;
  List<String> metrics = ['done/missed', 'units'];
  String selectedMetric = 'done/missed';
  String selectedPreset = AppConstant.presetValuesStrings[0];

  Widget headerText(title) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget saveButton() {
    return GestureDetector(
      onTap: () async {
        bool isBoolean = selectedMetric == metrics[0];
        if (title == '') {
          return;
        }
        if (!isBoolean && units == '') {
          return;
        }
        if (selectedPreset == '' || !AppConstant.presetValuesStrings.contains(selectedPreset)) {
          Navigator.pop(context);
          return;
        }

        final CollectionReference userHabitCollection =
            FirebaseFirestore.instance.collection(AppConstant.USER_COLLECTION).doc(UserModel.uid).collection('habits');
        final CollectionReference dummyColl = FirebaseFirestore.instance.collection(AppConstant.HABIT_COLLECTION);
        HabitModel obj = HabitModel(
          title: title,
          isBoolean: isBoolean,
          units: units,
          presetValue: selectedPreset,
          intervals: [],
        );
        var dummyMap = obj.toJson();
        dummyMap[AppConstant.FCMTOKEN] = UserModel.fcmToken;
        dummyMap[AppConstant.UID] = UserModel.uid;
        Navigator.pop(context);
        await userHabitCollection.add(obj.toJson());
        await dummyColl.add(dummyMap);
      },
      child: Container(
        alignment: Alignment.centerRight,
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 17, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget textInput(String initialValue, var change, String hintText) {
    return Theme(
      data: ThemeData(primaryColor: Colors.blue),
      child: TextFormField(
        maxLength: 200,
        style: const TextStyle(
          fontSize: 14,
        ),
        keyboardType: TextInputType.text,
        initialValue: initialValue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: -15),
          counterText: "",
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        onChanged: change,
      ),
    );
  }

  void check(t) {
    if (t.contains('wake') || t.contains('waking')) {
      selectedPreset = AppConstant.presetValuesStrings[1];
    } else if (t.contains('college') || t.contains('work') || t.contains('job')) {
      selectedPreset = AppConstant.presetValuesStrings[2];
    } else if (t.contains('study') || t.contains('read')) {
      selectedPreset = AppConstant.presetValuesStrings[3];
    } else if (t.contains('relax') || t.contains('chill')) {
      selectedPreset = AppConstant.presetValuesStrings[4];
    } else if (t.contains('gym') || t.contains('health') || t.contains('workout') || t.contains('exercise')) {
      selectedPreset = AppConstant.presetValuesStrings[5];
    } else if (t.contains('walk') || t.contains('step')) {
      selectedPreset = AppConstant.presetValuesStrings[7];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: DefaultAppBar.centerBack(context, 'Add Habit'),
        body: Container(
          constraints: const BoxConstraints.expand(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 30),
                headerText('Project Name'),
                textInput(title, (val) {
                  title = val;
                  check(title.toLowerCase());
                  setState(() {});
                }, 'Enter Habit Name here'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    headerText('Metric Type'),
                    const Spacer(),
                    DropdownButton<String>(
                      underline: const SizedBox(),
                      value: selectedMetric,
                      items: metrics.map((e) {
                        return DropdownMenuItem(child: Text(e), value: e);
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          selectedMetric = val;
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
                if (selectedMetric == metrics[1]) headerText('Units'),
                if (selectedMetric == metrics[1])
                  textInput(units, (val) {
                    setState(() {
                      units = val;
                    });
                  }, 'steps, minutes, hours, etc.'),
                const SizedBox(height: 20),
                // dropdown preset
                Row(
                  children: [
                    headerText('Preset Type'),
                    const Spacer(),
                    DropdownButton<String>(
                      underline: const SizedBox(),
                      value: selectedPreset,
                      items: AppConstant.presetValuesStrings.map((e) {
                        return DropdownMenuItem(child: Text(e), value: e);
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          selectedPreset = val;
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                saveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
