class SensorLuminositySettingsIos {
  double luminosityThreshold;

  SensorLuminositySettingsIos({this.luminosityThreshold});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["luminosityThreshold"] = luminosityThreshold;

    return map;
  }
}
