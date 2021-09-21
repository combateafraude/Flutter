class SensorStabilitySettingsIos {
  String? message;
  double? stabilityThreshold;

  SensorStabilitySettingsIos(
  {this.message, this.stabilityThreshold});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["message"] = message;
    map["stabilityThreshold"] = stabilityThreshold;

    return map;
  }
}
