class SensorStabilitySettingsAndroid {
  String? messageResourceIdName;
  int? stabilityStabledMillis;
  double? stabilityThreshold;

  SensorStabilitySettingsAndroid(
  {this.messageResourceIdName, this.stabilityStabledMillis, this.stabilityThreshold});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["messageResourceIdName"] = messageResourceIdName;
    map["stabilityStabledMillis"] = stabilityStabledMillis;
    map["stabilityThreshold"] = stabilityThreshold;

    return map;
  }
}
