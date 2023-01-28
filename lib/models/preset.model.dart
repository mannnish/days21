import 'package:cloud_firestore/cloud_firestore.dart';

class PresetModel {
  late String presetValue;
  late DateTime startTime;
  late DateTime endTime;

  PresetModel({
    required this.presetValue,
    required this.startTime,
    required this.endTime,
  });

  PresetModel.fromJson(Map<String, dynamic> json) {
    presetValue = json["preset_value"];
    startTime = (json["start_time"] as Timestamp).toDate();
    endTime = (json["end_time"] as Timestamp).toDate();
  }

  toJson() {
    return {
      "preset_value": presetValue,
      "start_time": startTime.toString(),
      "end_time": endTime.toString(),
    };
  }
}
