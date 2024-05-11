class SensorLuminositySettingsAndroid {
  int? luminosityThreshold;

  SensorLuminositySettingsAndroid({this.luminosityThreshold});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["luminosityThreshold"] = luminosityThreshold;

    return map;
  }
}
