class SensorOrientationSettingsIos {
  String? message;
  double? orientationThreshold;

  SensorOrientationSettingsIos(
  {this.message, this.orientationThreshold});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["orientationThreshold"] = orientationThreshold;

    return map;
  }
}
