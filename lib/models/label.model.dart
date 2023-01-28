class LabelModel {
  late String label;
  late int numOfDays;

  LabelModel({required this.label, required this.numOfDays});

  LabelModel.fromJson(json) {
    label = json["label"] ?? "label-text";
    if (json["numOfDays"] == null) {
      numOfDays = 30;
    } else {
      numOfDays = int.tryParse(json["numOfDays"].toString())!;
    }
  }

  toJson() {
    return {
      "label": label,
      "numOfDays": numOfDays,
    };
  }
}
