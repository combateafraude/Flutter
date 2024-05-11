class SensorOrientationSettingsIos {
  double? orientationThreshold;

  SensorOrientationSettingsIos({this.orientationThreshold});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["orientationThreshold"] = orientationThreshold;

    return map;
  }
}
