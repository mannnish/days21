import 'package:cloud_firestore/cloud_firestore.dart';
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
        // TODO : Implement if-else nlp xD
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
        HabitModel obj = HabitModel(
          title: title,
          isBoolean: isBoolean,
          units: units,
          presetValue: selectedPreset,
          intervals: [],
        );
        Navigator.pop(context);
        await userHabitCollection.add(obj.toJson());
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
                  setState(() {
                    title = val;
                  });
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
