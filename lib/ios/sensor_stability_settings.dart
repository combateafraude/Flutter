class SensorStabilitySettingsIos {
  double? stabilityThreshold;

  SensorStabilitySettingsIos(
  {this.stabilityThreshold});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["stabilityThreshold"] = stabilityThreshold;

    return map;
  }
}
