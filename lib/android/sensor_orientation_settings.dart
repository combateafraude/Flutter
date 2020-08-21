class SensorOrientationSettingsAndroid {
  String messageResourceIdName;
  double orientationThreshold;

  SensorOrientationSettingsAndroid(
      this.messageResourceIdName, this.orientationThreshold);

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["messageResourceIdName"] = messageResourceIdName;
    map["orientationThreshold"] = orientationThreshold;

    return map;
  }
}
