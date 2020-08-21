class SensorLuminositySettingsAndroid {
  String messageResourceIdName;
  int luminosityThreshold;

  SensorLuminositySettingsAndroid(
      this.messageResourceIdName, this.luminosityThreshold);

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["messageResourceIdName"] = messageResourceIdName;
    map["luminosityThreshold"] = luminosityThreshold;

    return map;
  }
}
