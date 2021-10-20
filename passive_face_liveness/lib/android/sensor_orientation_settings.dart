class SensorOrientationAndroid {
  String? messageResourceIdName;
  double? stabilityThreshold;

  SensorOrientationAndroid(
      {this.messageResourceIdName, this.stabilityThreshold});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["messageResourceIdName"] = messageResourceIdName;
    map["stabilityThreshold"] = stabilityThreshold;

    return map;
  }
}
