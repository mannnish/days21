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
    //..
  }

  toJson() {
    return {
      "preset_value": presetValue,
      "start_time": startTime.toString(),
      "end_time": endTime.toString(),
    };
  }
}
