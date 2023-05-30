class SensorOrientationAndroid {
  double orientationThreshold;

  SensorOrientationAndroid({this.orientationThreshold});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["orientationThreshold"] = orientationThreshold;

    return map;
  }
}
