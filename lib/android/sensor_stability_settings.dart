class SensorStabilitySettingsAndroid {
  int stabilityStabledMillis;
  double stabilityThreshold;

  SensorStabilitySettingsAndroid(
      {this.stabilityStabledMillis, this.stabilityThreshold});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["stabilityStabledMillis"] = stabilityStabledMillis;
    map["stabilityThreshold"] = stabilityThreshold;

    return map;
  }
}
